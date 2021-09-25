import 'dart:async';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:backrec_flutter/bloc/playback_bloc.dart';
import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/controllers/toast_controller.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/buttons/add_marker_button.dart';
import 'package:backrec_flutter/widgets/marker_progress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    setFocus(true);
  }

  setFocus(bool isPlaying) {
    setState(() {
      _inFocus = !_inFocus;
    });
    if (!_inFocus && isPlaying) {
      print("Getting in focus!");
      Timer.periodic(Duration(seconds: 3), (timer) {
        setState(() {
          _inFocus = true;
          timer.cancel();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxWidth;
          return BlocBuilder<PlaybackBloc, PlaybackState>(
            buildWhen: (oldState, newState) => true,
            builder: (context, state) {
              print(state);
              if (state is PlaybackInitialized || state is PlaybackPlaying) {
                final service = context.read<PlaybackBloc>().service;
                final isPlaying = service.isPlaying;
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
                            child: VideoPlayer(service.localController)),
                        //big play button
                        Align(
                          alignment: Alignment.center,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: _inFocus ? 0.0 : .5,
                            child: InkWell(
                              onTap: () {
                                setFocus(isPlaying);
                              },
                              child: Visibility(
                                visible: !_inFocus,
                                child: Container(
                                  width: width,
                                  height: height,
                                  color:
                                      GlobalColors.primaryGrey.withOpacity(1.0),
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 500),
                                    child: !isPlaying
                                        ? IconButton(
                                            iconSize: 100,
                                            icon: Icon(FontAwesomeIcons.play,
                                                color: Colors.white
                                                    .withOpacity(.3)),
                                            onPressed: () {
                                              print("PLAYYYY");
                                              context
                                                  .read<PlaybackBloc>()
                                                  .add(StartPlaybackEvent());
                                              setFocus(true);
                                            })
                                        : IconButton(
                                            iconSize: 100,
                                            icon: Icon(FontAwesomeIcons.pause,
                                                color: Colors.white
                                                    .withOpacity(.3)),
                                            onPressed: () {
                                              context
                                                  .read<PlaybackBloc>()
                                                  .add(StopPlaybackEvent());
                                              // timer.cancel();
                                              setFocus(false);
                                            }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //back
                        Container(
                          width: width,
                          height: height * .1,
                          child: InkWell(
                              onTap: () {
                                Get.back();
                                // Get.find<RecordController>().markers.clear();
                                service.localController.setVolume(0.0);
                              },
                              child: Row(
                                children: [
                                  Icon(FeatherIcons.chevronLeft,
                                      color: Colors.white, size: 20),
                                  Text(
                                    "Record",
                                    style: Get.textTheme.bodyText1!.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  )
                                ],
                              )),
                        ),
                        //bottom bar, actions and buttons
                        AnimatedPositioned(
                          bottom: _inFocus ? -30 : 0,
                          duration: Duration(milliseconds: 200),
                          child: Container(
                            width: width,
                            height: 150,
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Stack(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //actions - prev, next marker
                                Positioned(
                                  bottom: 60,
                                  left: 0,
                                  child: Container(
                                    height: height * .15,
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Tooltip(
                                          message: 'Jump to previous marker',
                                          child: InkWell(
                                            onTap: () {
                                              Vibration.vibrate(duration: 50);
                                              service.jumpToPreviousMarker();
                                            },
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      GlobalColors.primaryRed),
                                              child: Center(
                                                child: Icon(
                                                    FeatherIcons.skipBack,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // color: Colors.black,
                                          width: width * .8,
                                          height: 50,
                                          child: Stack(
                                              children: service.markers
                                                  .map((e) => MarkerPin(
                                                      marker: e,
                                                      totalWidth: width * .8,
                                                      onMarkerTap: () {
                                                        service.onMarkerTap(
                                                            e.startPosition);
                                                      },
                                                      totalDuration: service
                                                          .localController
                                                          .value
                                                          .duration))
                                                  .toList()),
                                        ),
                                        Tooltip(
                                          message: 'Jump to next marker',
                                          child: InkWell(
                                            onTap: () async {
                                              // HapticFeedback.lightImpact();
                                              Vibration.vibrate(duration: 50);
                                              service.jumpToNextMarker();
                                            },
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      GlobalColors.primaryRed),
                                              child: Center(
                                                child: Icon(
                                                    FeatherIcons.skipForward,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                // playback bar with markers on it,
                                ,
                                Positioned(
                                  bottom: 40,
                                  left: 0,
                                  child: Container(
                                    width: width,
                                    // color: Colors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: ValueListenableBuilder(
                                          valueListenable:
                                              ValueNotifier(service.elapsed),
                                          builder:
                                              (context, Duration value, child) {
                                            return ProgressBar(
                                              progress: value,
                                              total: service.totalDuration,
                                              timeLabelLocation:
                                                  TimeLabelLocation.sides,
                                              timeLabelTextStyle: Get
                                                  .textTheme.bodyText1!
                                                  .copyWith(
                                                      color: Colors.white),
                                              thumbColor: Colors.white,
                                              baseBarColor: GlobalColors
                                                  .primaryGrey
                                                  .withOpacity(.3),
                                              progressBarColor:
                                                  GlobalColors.primaryRed,
                                              onSeek: service.onSeek,
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                                // bottom action and infos
                                Positioned(
                                  bottom: 0,
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity: _inFocus ? 0.0 : 1.0,
                                    child: Container(
                                      width: width,
                                      child: Stack(
                                        children: [
                                          //play/pause and info row
                                          Row(
                                            children: [
                                              AnimatedSwitcher(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                child: !service.isPlaying
                                                    ? IconButton(
                                                        iconSize: 20,
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .play,
                                                            color:
                                                                Colors.white),
                                                        onPressed: () {
                                                          print("PLAY");
                                                          context
                                                              .read<
                                                                  PlaybackBloc>()
                                                              .add(
                                                                  StartPlaybackEvent());
                                                          setFocus(true);
                                                        })
                                                    : IconButton(
                                                        iconSize: 20,
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .pause,
                                                            color:
                                                                Colors.white),
                                                        onPressed: () {
                                                          service.onPause();
                                                          // timer.cancel();
                                                        }),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                child: Container(
                                                  width: 130,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(widget.homeTeam.name,
                                                          style: Get.textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white)),
                                                      Text("VS",
                                                          style: Get.textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                      Text(widget.awayTeam.name,
                                                          style: Get.textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white)),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          //trash - to delete video
                                          Positioned(
                                            right: 0,
                                            child: IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.trashAlt,
                                                  color: Colors.white),
                                              onPressed: () {},
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                                endPosition: service.elapsed,
                                homeTeam: widget.homeTeam,
                                awayTeam: widget.awayTeam,
                                onTap: () async {
                                  await service.localController.pause();
                                },
                                onCancel: () async {
                                  await service.localController.play();
                                },
                                onMarkerConfigured: (marker) async {
                                  service.saveMarker(marker);
                                  Get.find<ToastController>().showToast(
                                      "Marker created successfully",
                                      Icon(Icons.check, color: Colors.white));
                                  await service.localController.play();
                                },
                              ),
                            ))
                      ],
                    ));
              } else {
                return Container();
              }
            },
          );
        }),
      ),
    );
  }
}
