import 'dart:async';
import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/extensions/list_ext.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/core/utils/ui_utils.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/bar_actions.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/marker_info.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/overlay_actions.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/domain/repositories/marker_repository.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/marker_dialog.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/add_marker_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

class PlaybackScreen extends StatefulWidget {
  final Team? homeTeam, awayTeam;
  const PlaybackScreen({Key? key, this.homeTeam, this.awayTeam})
      : super(key: key);

  @override
  _PlaybackScreenState createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  // List<Marker> markers = [];
  Timer? timer;
  bool _inFocus = true;
  late VideoPlayerController controller;
  Marker? currentMarker;
  bool isMarkerVisible = false;

  @override
  void initState() {
    super.initState();
    setFocus(true);
  }

  setFocus(bool isPlaying) {
    if (!_inFocus && isPlaying) {
      print("Getting in focus!");
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        setState(() {
          _inFocus = true;
          timer.cancel();
        });
      });
    } else {
      setState(() {
        _inFocus = !_inFocus;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.removeListener(videoPlayerListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final notchPadding = MediaQuery.of(context).viewPadding;
    return Scaffold(
        body: SafeArea(
      child: BlocConsumer<PlaybackBloc, PlaybackState>(
        listener: (context, state) {
          if (state is PlaybackInitialized) {
            controller = state.controller;
            controller.addListener(videoPlayerListener);
          } else if (state is PlaybackError) {
            print(state.message);
          } else if (state is MarkerPlayback) {
            setState(() {
              currentMarker = state.marker;
            });
          }
        },
        buildWhen: (oldState, newState) =>
            oldState.runtimeType != newState.runtimeType,
        builder: (context, state) {
          print(state);
          if (state is PlaybackInitialized ||
              state is PlaybackPlaying ||
              state is PlaybackStopped) {
            // final service = context.read<PlaybackBloc>().service;
            return ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, VideoPlayerValue value, child) {
                  final isPlaying = value.isPlaying;
                  final totalDuration = value.duration;
                  final elapsed = value.position;
                  return Container(
                      width: width,
                      height: height,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: value.size.width,
                              height: value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),
                          SizedBox(
                            height: height,
                            width: width,
                            child: GestureDetector(
                              onTap: () {
                                setFocus(isPlaying);
                              },
                            ),
                          ),
                          //big play button
                          OverlayActions(
                            setFocus: () {
                              setFocus(isPlaying);
                            },
                            onPressed: () {
                              setFocus(true);
                              if (isPlaying) {
                                context
                                    .read<PlaybackBloc>()
                                    .add(StopPlaybackEvent());
                              } else {
                                context
                                    .read<PlaybackBloc>()
                                    .add(StartPlaybackEvent());
                              }
                            },
                            inFocus: _inFocus,
                            isPlaying: isPlaying,
                          ),
                          //back
                          Positioned(
                            left: 20,
                            top: 20,
                            child: TextButton.icon(
                                onPressed: () {
                                  NavUtils.back(context);
                                  context
                                      .read<PlaybackBloc>()
                                      .add(PlaybackVolumeEvent(0.0));
                                },
                                icon: Icon(FeatherIcons.chevronLeft,
                                    color: Colors.white, size: 20),
                                label: Text(
                                  "Record",
                                  style: context.bodyText1.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline),
                                )),
                          ),
                          //bottom bar, actions and buttons
                          AnimatedPositioned(
                            bottom: _inFocus ? -30 : 0,
                            duration: kThemeAnimationDuration,
                            child: MultiRepositoryProvider(
                              providers: [
                                RepositoryProvider(
                                  create: (context) => sl<MarkerRepository>(),
                                ),
                                RepositoryProvider(
                                  create: (context) => sl<PlaybackRepository>(),
                                ),
                              ],
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => sl<MarkerCubit>(),
                                  ),
                                  BlocProvider(
                                    create: (context) => sl<PlaybackBloc>(),
                                  ),
                                ],
                                child: Padding(
                                  padding: notchPadding,
                                  child: VideoPlayerActions(
                                      onPause: () {
                                        context
                                            .read<PlaybackBloc>()
                                            .add(StopPlaybackEvent());
                                        setFocus(true);
                                      },
                                      onPlay: () {
                                        context
                                            .read<PlaybackBloc>()
                                            .add(StartPlaybackEvent());
                                        setFocus(true);
                                      },
                                      onMarkerTap: (marker) {
                                        print("Seek: ${marker.endPosition}");
                                        context.read<PlaybackBloc>().add(
                                            SeekPlaybackEvent(
                                                marker.endPosition));
                                        currentMarker = marker;
                                      },
                                      onJumpBackward: () {
                                        UiUtils.vibrate();
                                        jumpToPreviousMarker(elapsed);
                                      },
                                      onJumpForward: () {
                                        UiUtils.vibrate();
                                        jumpToNextMarker(elapsed);
                                      },
                                      // markers: markers,
                                      controller: controller,
                                      inFocus: _inFocus,
                                      isPlaying: isPlaying,
                                      awayTeam: widget.awayTeam,
                                      homeTeam: widget.homeTeam,
                                      totalDuration: totalDuration,
                                      onSeek: (duration) {
                                        print("Seek: $duration");
                                        context
                                            .read<PlaybackBloc>()
                                            .add(SeekPlaybackEvent(duration));
                                      },
                                      setTeams: (home, away) {},
                                      onMarkerPlayback: () {
                                        final markers =
                                            context.read<MarkerCubit>().markers;
                                        context
                                            .read<PlaybackBloc>()
                                            .add(MarkerPlaybackEvent(markers));
                                      }),
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: ValueListenableBuilder<Marker?>(
                                  valueListenable: ValueNotifier(currentMarker),
                                  builder: (context, value, child) {
                                    if (value == null) {
                                      return SizedBox();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: MarkerInfo(
                                        marker: currentMarker!,
                                        homeTeam: widget.homeTeam,
                                        awayTeam: widget.awayTeam,
                                        visible: isMarkerVisible,
                                        onMarkerConfigured: (marker) {
                                          context
                                              .read<MarkerCubit>()
                                              .updateMarker(marker);
                                          setState(() {});
                                        },
                                        onDelete: () {
                                          context
                                              .read<MarkerCubit>()
                                              .removeMarker(currentMarker!);
                                          setState(() {});
                                        },
                                      ),
                                    );
                                  })),
                          Positioned(
                              right: 20,
                              top: 20,
                              child: Tooltip(
                                  message: 'Add new marker',
                                  verticalOffset: 30,
                                  decoration: BoxDecoration(
                                      color: GlobalColors.primaryRed,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: NewMarkerButton(
                                    endPosition: elapsed,
                                    onTap: () async {
                                      context
                                          .read<PlaybackBloc>()
                                          .add(StopPlaybackEvent());
                                      setFocus(true);
                                      final interfering = context
                                          .read<MarkerCubit>()
                                          .isInterfereing(elapsed);
                                      if (!interfering) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => MarkerDialog(
                                                  endPosition: elapsed,
                                                  homeTeam: widget.homeTeam,
                                                  awayTeam: widget.awayTeam,
                                                  onMarkerConfigured: (marker) {
                                                    // service.saveMarker(marker);
                                                    UiUtils.showToast(
                                                        "Marker created successfully!");
                                                    context
                                                        .read<MarkerCubit>()
                                                        .addMarker(marker);
                                                    setState(() {});
                                                  },
                                                  onCancel: () {},
                                                  onDelete: () {
                                                    // context.read<MarkerCubit>().removeMarker(marker);
                                                  },
                                                ));
                                      }
                                    },
                                  ))),
                        ],
                      ));
                });
          } else {
            return Center(
                child:
                    CircularProgressIndicator(color: GlobalColors.primaryRed));
          }
        },
      ),
    ));
  }

  void videoPlayerListener() {
    final elapsed = controller.value.position;
    setState(() {
      isMarkerVisible = markerVisible(elapsed);
    });
  }

  void jumpToPreviousMarker(Duration elapsed) {
    final prevMarker = context.read<MarkerCubit>().findPreviousMarker(elapsed);
    if (prevMarker != null) {
      context
          .read<PlaybackBloc>()
          .add(SeekPlaybackEvent(prevMarker.startPosition));
    }
  }

  void jumpToNextMarker(Duration elapsed) {
    final nextMarker = context.read<MarkerCubit>().findNextMarker(elapsed);
    if (nextMarker != null) {
      context
          .read<PlaybackBloc>()
          .add(SeekPlaybackEvent(nextMarker.startPosition));
    }
  }

  bool markerVisible(Duration elapsed) {
    return context.read<MarkerCubit>().markerVisible(elapsed);
  }
}
