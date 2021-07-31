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
  late PlaybackController playbackController = Get.put(PlaybackController(
      video: widget.video!, looping: true, hasVolume: false));

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<Offset> _animation =
      Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
          .animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void initState() {
    //Onitialize videoController
    super.initState();
    _controller.forward(); //start animation
  }

  @override
  void dispose() {
    _controller.dispose();
    // localVideoController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => PlaybackScreen(
              video: widget.video!,
              homeTeam: widget.homeTeam,
              awayTeam: widget.awayTeam,
            ));
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
                  borderRadius: BorderRadius.circular(8),
                  child: VideoPlayer(controller.localController),
                ),
              ),
            );
          }),
    );
  }
}
