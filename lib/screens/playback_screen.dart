import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PlaybackScreen extends StatefulWidget {
  final XFile video;
  const PlaybackScreen({Key? key, required this.video}) : super(key: key);

  @override
  _PlaybackScreenState createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  late VideoPlayerController localController;

  Duration elapsed = Duration(seconds: 0);

  VoidCallback? videoPlayerListener;

  @override
  void initState() {
    initVideoPlayer();
    print("Total duration: ${localController.value.duration}");
    elapsed = localController.value.position;
    super.initState();
  }

  void initVideoPlayer() async {
    print("init video player - Getting file: ${widget.video.name}");

    localController = VideoPlayerController.file(File(widget.video.path));
    videoPlayerListener = () {
      if (localController != null && localController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        localController.removeListener(videoPlayerListener!);
      }
    };
    localController.addListener(videoPlayerListener!);
    await localController.setLooping(false);
    await localController.initialize();
    localController.setVolume(0.0);
    localController.play();
  }

  @override
  void dispose() {
    localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            VideoPlayer(localController),
            Container(
              width: Get.width,
              height: Get.height * .1,
              // color: GlobalColors.primaryGrey.withOpacity(.4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
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
                      ))
                ],
              ),
            ),
            //bottom bar, actions and buttons
            Positioned(
              bottom: 0,
              child: Container(
                width: Get.width,
                height: 120,
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Column(
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
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: Get.width * .9,
                          child: ProgressBar(
                            progress: elapsed,
                            // buffered: Duration(seconds: 1),
                            total: localController.value.duration,
                            timeLabelLocation: TimeLabelLocation.none,
                            timeLabelTextStyle: Get.textTheme.bodyText1!
                                .copyWith(color: Colors.white),
                            thumbColor: Colors.white,
                            baseBarColor:
                                GlobalColors.primaryGrey.withOpacity(.3),
                            progressBarColor: GlobalColors.primaryRed,
                            onSeek: (duration) {
                              print("Duration: $duration");
                              setState(() {
                                localController.seekTo(duration);
                                // localController.play();
                                elapsed =
                                    // localController.value.position +
                                    duration;
                              });
                              print(localController.value.position);
                            },
                          ),
                        ),
                      ),
                      // bottom action and infos
                      Row(
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: !localController.value.isPlaying
                                ? IconButton(
                                    iconSize: 20,
                                    icon: Icon(FontAwesomeIcons.play,
                                        color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        localController.play();
                                      });
                                      print(
                                          "Player Started, because: ${localController.value.isPlaying}");
                                    },
                                  )
                                : IconButton(
                                    iconSize: 20,
                                    icon: Icon(FontAwesomeIcons.pause,
                                        color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        localController.pause();
                                      });
                                      print(
                                          "Player Paused, because: ${localController.value.isPlaying}");
                                    },
                                  ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
