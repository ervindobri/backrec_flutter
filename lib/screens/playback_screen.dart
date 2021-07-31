import 'dart:io';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/controllers/playback_controller.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  late PlaybackController playbackController = Get.put(PlaybackController(
      video: widget.video, hasVolume: true //set the player volume
      ));

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
                  Container(
                    width: Get.width,
                    height: Get.height * .1,
                    child: InkWell(
                        onTap: () {
                          Get.back();
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
                      height: 130,
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //actions - prev, next marker
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    //TODO: prev marker, jump to that time (-12 sec)
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
                                InkWell(
                                  onTap: () {
                                    //TODO: next marker, jump to that time (-12 sec)
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
                            )
                            // playback bar with markers on it,
                            ,
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                width: Get.width * .9,
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
                            // bottom action and infos
                            Row(
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
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 20,
                      top: 20,
                      child: Tooltip(
                        message: 'Add new marker',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  FeatherIcons.plusCircle,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
