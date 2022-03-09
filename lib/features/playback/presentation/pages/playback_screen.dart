import 'dart:async';
import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/core/utils/ui_utils.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/bar_actions.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/blurry_icon_button.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/cut_dialog.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/marker_info.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/overlay_actions.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/domain/repositories/marker_repository.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/marker_dialog.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/add_marker_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
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

  bool noMoreMarkers = false;

  @override
  void initState() {
    super.initState();
    setFocus(true);
  }

  setFocus(bool isPlaying, {bool instant = true}) {
    print("Setting focus: ${!_inFocus}, instant: $instant");
    if (isPlaying) {
      //If it's playing watch instant flag
      if (instant) {
        //start playing - focus immediately
        setState(() {
          _inFocus = !_inFocus;
          timer?.cancel();
        });
      } else {
        //focus after delay
        // print("Getting in focus!");
        reverseFocus(isPlaying);
      }
    } else {
      //If not playing change focius instantly
      setState(() {
        _inFocus = !_inFocus;
        timer?.cancel();
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
    final double leftPadding = notchPadding.left > 0.0 ? notchPadding.left : 10;
    final double rightPadding =
        notchPadding.right > 0.0 ? notchPadding.right : 10;
    final double topPadding = notchPadding.top > 0.0 ? notchPadding.top : 10;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(0, topPadding, 0, 0),
      child: BlocListener<MarkerCubit, MarkerState>(
        listener: (context, state) {
          if (state is MarkerRemoved) {
            UiUtils.showToast("Marker deleted!");
          }
        },
        child: BlocConsumer<PlaybackBloc, PlaybackState>(
          listener: (context, state) {
            if (state is PlaybackInitialized) {
              controller = state.controller;
              controller.addListener(videoPlayerListener);
            } else if (state is PlaybackError) {
              // print("PlaybackError: ${state.message}");
            } else if (state is MarkerPlayback) {
              setState(() {
                currentMarker = state.marker;
              });
            }
          },
          buildWhen: (oldState, newState) =>
              oldState.runtimeType != newState.runtimeType,
          builder: (context, state) {
            // print(state);
            if (state is PlaybackInitialized ||
                state is PlaybackPlaying ||
                state is PlaybackStopped ||
                state is MarkerPlayback) {
              // final service = context.read<PlaybackBloc>().service;
              return ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, VideoPlayerValue value, child) {
                    final isPlaying = value.isPlaying;
                    final totalDuration = value.duration;
                    final elapsed = value.position;
                    final size = MediaQuery.of(context).size;
                    final deviceRatio = size.width / size.height;
                    final finished = elapsed == value.duration;
                    return Container(
                        width: width,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.cover,
                              child: Transform.scale(
                                alignment: Alignment.center,
                                scale:
                                    deviceRatio / controller.value.aspectRatio,
                                child: SizedBox(
                                  width: value.size.width,
                                  height: value.size.height,
                                  child: VideoPlayer(controller),
                                ),
                              ),
                            ),
                            //big play button
                            Padding(
                              padding: notchPadding,
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => sl<PlaybackBloc>(),
                                  ),
                                  BlocProvider(
                                    create: (context) => sl<MarkerCubit>(),
                                  ),
                                ],
                                child: OverlayActions(
                                  finishedPlaying: finished,
                                  setFocus: () => setFocus(isPlaying),
                                  onPressed: () {
                                    if (isPlaying) {
                                      context
                                          .read<PlaybackBloc>()
                                          .add(StopPlaybackEvent());
                                      setFocus(isPlaying, instant: false);
                                    } else {
                                      context
                                          .read<PlaybackBloc>()
                                          .add(StartPlaybackEvent());
                                      setFocus(false, instant: false);
                                    }
                                  },
                                  inFocus: _inFocus,
                                  isPlaying: isPlaying,
                                ),
                              ),
                            ),
                            //back button
                            AnimatedPositioned(
                              left: leftPadding,
                              top: !_inFocus ? 10 : -50,
                              duration: kThemeAnimationDuration,
                              child: AnimatedOpacity(
                                duration: kThemeAnimationDuration,
                                opacity: !_inFocus ? 1.0 : 0.3,
                                child: BlurryIconButton(
                                  onPressed: () {
                                    NavUtils.back(context);
                                    context
                                        .read<PlaybackBloc>()
                                        .add(PlaybackVolumeEvent(0.0));
                                  },
                                  icon: FeatherIcons.chevronLeft,
                                  decoration: TextDecoration.underline,
                                  label: "Record",
                                ),
                              ),
                            ),
                            //bottom bar, actions and buttons
                            AnimatedPositioned(
                              bottom: _inFocus ? -32 : 0,
                              left: 0,
                              duration: kThemeAnimationDuration,
                              child: MultiRepositoryProvider(
                                providers: [
                                  RepositoryProvider(
                                    create: (context) => sl<MarkerRepository>(),
                                  ),
                                  RepositoryProvider(
                                    create: (context) =>
                                        sl<PlaybackRepository>(),
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
                                        // print("Seek: ${marker.endPosition}");
                                        context.read<PlaybackBloc>().add(
                                            SeekPlaybackEvent(
                                                marker.endPosition));
                                        currentMarker = marker;
                                      },
                                      onJumpBackward: () {
                                        jumpToPreviousMarker(elapsed);
                                        UiUtils.vibrate();
                                      },
                                      onJumpForward: () {
                                        jumpToNextMarker(elapsed);
                                        UiUtils.vibrate();
                                      },
                                      // markers: markers,
                                      controller: controller,
                                      inFocus: _inFocus,
                                      isPlaying: isPlaying,
                                      awayTeam: widget.awayTeam,
                                      homeTeam: widget.homeTeam,
                                      totalDuration: totalDuration,
                                      currentMarker: currentMarker,
                                      onSeek: (duration) {
                                        // print("Seek: ");
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
                            Align(
                                alignment: Alignment.topCenter,
                                child: ValueListenableBuilder<Marker?>(
                                    valueListenable:
                                        ValueNotifier(currentMarker),
                                    builder: (context, value, child) {
                                      if (value == null) {
                                        return SizedBox();
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
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
                                right: rightPadding,
                                top: 10,
                                child: Tooltip(
                                    message: 'Add new marker',
                                    verticalOffset: 30,
                                    decoration: BoxDecoration(
                                        color: GlobalColors.primaryRed,
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                              useSafeArea: false,
                                              builder: (_) => MarkerDialog(
                                                    endPosition: elapsed,
                                                    homeTeam: widget.homeTeam,
                                                    awayTeam: widget.awayTeam,
                                                    onMarkerConfigured:
                                                        (marker) {
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
                                        } else {
                                          UiUtils.showToast(
                                              "New marker is interfereing with existing ones!");
                                        }
                                      },
                                    ))),
                            AnimatedPositioned(
                              right: noMoreMarkers ? rightPadding : -100.0,
                              top: 78,
                              duration: kThemeAnimationDuration,
                              child: BlurryIconButton(
                                onPressed: () {
                                  final videoPath =
                                      sl<PlaybackRepository>().path;
                                  final markers = sl<MarkerCubit>().markers;
                                  //open cut dialog
                                  context
                                      .read<PlaybackBloc>()
                                      .add(StopPlaybackEvent());
                                  context.read<MarkerCubit>().saveData(
                                      sl<PlaybackRepository>().videoNameParsed);
                                  openCutDialog(context, videoPath, markers);
                                },
                                color: GlobalColors.primaryRed,
                                label: "Cut",
                                icon: CupertinoIcons.scissors_alt,
                              ),
                            )
                          ],
                        ));
                  });
            } else {
              return Center(
                  child: CircularProgressIndicator(
                      color: GlobalColors.primaryRed));
            }
          },
        ),
      ),
    ));
  }

  void videoPlayerListener() {
    final elapsed = controller.value.position;
    setState(() {
      noMoreMarkers = context.read<MarkerCubit>().noMoreMarkers(elapsed);
      currentMarker = markerVisible(elapsed);
      isMarkerVisible = currentMarker != null;
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
      context.read<PlaybackBloc>().add(StartPlaybackEvent());
    }
  }

  Marker? markerVisible(Duration elapsed) {
    return context.read<MarkerCubit>().markerVisible(elapsed);
  }

  void reverseFocus(bool isPlaying) {
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (isPlaying) {
        setState(() {
          _inFocus = !_inFocus;
          timer.cancel();
        });
      }
    });
  }
}
