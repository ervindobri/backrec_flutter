import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/controllers/playback_controller.dart';
import 'package:backrec_flutter/controllers/record_controller.dart';
import 'package:backrec_flutter/controllers/toast_controller.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/buttons/add_marker_button.dart';
import 'package:backrec_flutter/widgets/marker_progress.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PlaybackScreen extends StatefulWidget {
  final XFile video;
  final Team homeTeam, awayTeam;
  const PlaybackScreen(
      {Key? key,
      required this.video,
      required this.homeTeam,
      required this.awayTeam})
      : super(key: key);

  @override
  _PlaybackScreenState createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  late PlaybackController playbackController = Get.find();
  List<Marker> markers = [];

  @override
  void initState() {
    playbackController.localController.setVolume(1.0);
    playbackController.markers.value = Get.find<RecordController>().markers;
    print("Markers: ${markers.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: GetBuilder<PlaybackController>(
            init: playbackController,
            builder: (controller) {
              return Stack(
                children: [
                  VideoPlayer(controller.localController),
                  //back
                  Container(
                    width: Get.width,
                    height: Get.height * .1,
                    child: InkWell(
                        onTap: () {
                          Get.back();
                          Get.find<RecordController>().markers.clear();
                          controller.localController.setVolume(0.0);
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
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: Get.width,
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
                              height: Get.height * .15,
                              width: Get.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.jumpToPreviousMarker();
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: GlobalColors.primaryRed),
                                      child: Center(
                                        child: Icon(FeatherIcons.skipBack,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      // color: Colors.black,
                                      width: Get.width * .8,
                                      height: 50,
                                      child: Obx(
                                        () => Stack(
                                            children: controller.markers
                                                .map((e) => MarkerPin(
                                                    marker: e,
                                                    totalWidth: Get.width * .8,
                                                    onMarkerTap: () {
                                                      controller.onMarkerTap(
                                                          e.startPosition);
                                                    },
                                                    totalDuration:
                                                        playbackController
                                                            .localController
                                                            .value
                                                            .duration))
                                                .toList()),
                                      )),
                                  InkWell(
                                    onTap: () {
                                      controller.jumpToNextMarker();
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: GlobalColors.primaryRed),
                                      child: Center(
                                        child: Icon(FeatherIcons.skipForward,
                                            color: Colors.white),
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
                              width: Get.width,
                              // color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Obx(
                                  () => ProgressBar(
                                    progress: controller.elapsed.value,
                                    total: controller.totalDuration,
                                    timeLabelLocation: TimeLabelLocation.sides,
                                    timeLabelTextStyle: Get.textTheme.bodyText1!
                                        .copyWith(color: Colors.white),
                                    thumbColor: Colors.white,
                                    baseBarColor: GlobalColors.primaryGrey
                                        .withOpacity(.3),
                                    progressBarColor: GlobalColors.primaryRed,
                                    onSeek: controller.onSeek,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // bottom action and infos
                          Positioned(
                            bottom: 0,
                            child: Row(
                              children: [
                                Obx(
                                  () => AnimatedSwitcher(
                                    duration: Duration(milliseconds: 500),
                                    child: !controller.isPlaying
                                        ? IconButton(
                                            iconSize: 20,
                                            icon: Icon(FontAwesomeIcons.play,
                                                color: Colors.white),
                                            onPressed: controller.onPlay)
                                        : IconButton(
                                            iconSize: 20,
                                            icon: Icon(FontAwesomeIcons.pause,
                                                color: Colors.white),
                                            onPressed: controller.onPause),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Container(
                                    width: 130,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.homeTeam.name,
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(color: Colors.white)),
                                        Text("VS",
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        Text(widget.awayTeam.name,
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
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
                        child: Obx(
                          () => NewMarkerButton(
                            endPosition: controller.elapsed.value,
                            homeTeam: widget.homeTeam,
                            awayTeam: widget.awayTeam,
                            onMarkerConfigured: (marker) {
                              controller.saveMarker(marker);
                              Get.find<ToastController>().showToast(
                                  "Marker created successfully",
                                  Icon(Icons.check, color: Colors.white));
                            },
                          ),
                        ),
                      ))
                ],
              );
            }),
      ),
    );
  }
}
