import 'dart:math';
import 'package:backrec_flutter/controllers/playback_controller.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/screens/playback_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class RecordedVideoThumbnail extends StatefulWidget {
  final XFile? video;
  final Team homeTeam, awayTeam;

  const RecordedVideoThumbnail({
    Key? key,
    // required this.onPressed,
    // required this.controller,
    this.video,
    required this.homeTeam,
    required this.awayTeam,
  }) : super(key: key);

  @override
  _RecordedVideoThumbnailState createState() => _RecordedVideoThumbnailState();
}

class _RecordedVideoThumbnailState extends State<RecordedVideoThumbnail>
    with TickerProviderStateMixin {
  late PlaybackController playbackController;

  @override
  void initState() {
    playbackController = Get.put(PlaybackController(
        video: widget.video!, looping: true, hasVolume: false));
    print("init record thumbnail - ${widget.video!.name}");
    super.initState();
  }

  //TODO: refresh video to the latest recorded ( controller is already initialized)
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
            () => PlaybackScreen(
                  video: widget.video!,
                  homeTeam: widget.homeTeam,
                  awayTeam: widget.awayTeam,
                ),
            fullscreenDialog: true,
            transition: Transition.downToUp);
      },
      child: GetBuilder<PlaybackController>(
          init: playbackController,
          builder: (controller) {
            return Container(
              width: min(Get.width / 10, 55),
              height: Get.width / 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: VideoPlayer(playbackController.localController),
                ),
              ),
            );
          }),
    );
  }
}
