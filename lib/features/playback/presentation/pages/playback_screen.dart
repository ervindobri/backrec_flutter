import 'dart:async';
import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/core/utils/ui_utils.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/bar_actions.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/overlay_actions.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/add_marker_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

class PlaybackScreen extends StatefulWidget {
  final Team homeTeam, awayTeam;
  const PlaybackScreen(
      {Key? key, required this.homeTeam, required this.awayTeam})
      : super(key: key);

  @override
  _PlaybackScreenState createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  List<Marker> markers = [];
  late Timer timer;
  bool _inFocus = true;
  late VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    setFocus(true);
  }

  setFocus(bool isPlaying) {
    if (!_inFocus && isPlaying) {
      print("Getting in focus!");
      Timer.periodic(Duration(seconds: 3), (timer) {
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
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: BlocConsumer<PlaybackBloc, PlaybackState>(
        listener: (context, state) {
          if (state is PlaybackInitialized) {
            controller = state.controller;
          }
        },
        buildWhen: (oldState, newState) => true,
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
                  print("Is playing: $isPlaying");
                  return Container(
                      width: width,
                      height: height,
                      child: Stack(
                        children: [
                          GestureDetector(
                              onTap: () {
                                print("tapped video player!");
                                setFocus(isPlaying);
                              },
                              child: VideoPlayer(controller)),
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
                          TextButton.icon(
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
                          //bottom bar, actions and buttons
                          AnimatedPositioned(
                            bottom: _inFocus ? -30 : 0,
                            duration: kThemeAnimationDuration,
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
                                context
                                    .read<PlaybackBloc>()
                                    .add(SeekPlaybackEvent(marker.endPosition));
                              },
                              onJumpBackward: () {
                                Vibration.vibrate();
                                jumpToPreviousMarker(elapsed);
                              },
                              onJumpForward: () {
                                Vibration.vibrate();
                                jumpToNextMarker(elapsed);
                              },
                              markers: markers,
                              controller: controller,
                              inFocus: _inFocus,
                              isPlaying: isPlaying,
                              awayTeam: widget.awayTeam,
                              homeTeam: widget.homeTeam,
                              totalDuration: totalDuration,
                              onSeek: (duration) {
                                context
                                    .read<PlaybackBloc>()
                                    .add(SeekPlaybackEvent(duration));
                              },
                            ),
                          ),
                          Positioned(
                              right: 10,
                              top: 10,
                              child: Tooltip(
                                  message: 'Add new marker',
                                  verticalOffset: 30,
                                  decoration: BoxDecoration(
                                      color: GlobalColors.primaryRed,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: NewMarkerButton(
                                    endPosition: elapsed,
                                    homeTeam: widget.homeTeam,
                                    awayTeam: widget.awayTeam,
                                    onTap: () async {
                                      await controller.pause();
                                    },
                                    onCancel: () async {
                                      // if (isPlaying) {
                                      // await controller.play();
                                      // }
                                    },
                                    onMarkerConfigured: (marker) async {
                                      // service.saveMarker(marker);
                                      UiUtils.showToast(
                                          "Marker created successfully!");
                                      setState(() => sl<PlaybackRepository>()
                                          .markers
                                          .add(marker));
                                      // await controller.play();
                                    },
                                  )))
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

  void jumpToPreviousMarker(Duration elapsed) {
    if (markers.length > 0) {
      var closest = markers.reduce((a, b) =>
          (a.endPosition.inMilliseconds - elapsed.inMilliseconds).abs() <
                  (b.endPosition.inMilliseconds - elapsed.inMilliseconds).abs()
              ? a
              : b);
      print(closest.startPosition);
      if (closest.endPosition != Duration.zero) {
        context
            .read<PlaybackBloc>()
            .add(SeekPlaybackEvent(closest.startPosition));
      }
    }
  }

  void jumpToNextMarker(Duration elapsed) {
    if (markers.length > 0) {
      Marker firstMarker = markers.firstWhere(
          (element) => element.startPosition > elapsed,
          orElse: () => Marker());
      if (firstMarker.endPosition != Duration.zero) {
        context
            .read<PlaybackBloc>()
            .add(SeekPlaybackEvent(firstMarker.startPosition));
      }
    }
  }
}
