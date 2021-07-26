import 'dart:io';
import 'dart:typed_data';

import 'package:backrec_flutter/screens/video_player_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class RecordedVideoThumbnail extends StatefulWidget {
  // final VoidCallback onPressed;
  final XFile? video;
  // final VideoPlayerController controller;
  const RecordedVideoThumbnail(
      {Key? key,
      // required this.onPressed,
      // required this.controller,
      this.video})
      : super(key: key);

  @override
  _RecordedVideoThumbnailState createState() => _RecordedVideoThumbnailState();
}

class _RecordedVideoThumbnailState extends State<RecordedVideoThumbnail>
    with TickerProviderStateMixin {
  late VideoPlayerController? localVideoController;

  VoidCallback? videoPlayerListener;

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
    localVideoController = VideoPlayerController.file(File(widget.video!.path));
    // TODO: implement initState
    super.initState();
    print("Length: ${widget.video!.name}");
    initVideoPlayer();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    localVideoController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => VideoPlayerScreen(controller: localVideoController!));
      },
      child: Container(
        width: Get.width / 10,
        height: Get.width / 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          // color: Colors.white,
          // width: 3,
          // )),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: VideoPlayer(localVideoController!)),
      ),
    );
  }

  void initVideoPlayer() async {
    videoPlayerListener = () {
      if (localVideoController != null &&
          localVideoController!.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        localVideoController!.removeListener(videoPlayerListener!);
      }
    };
    localVideoController!.addListener(videoPlayerListener!);
    await localVideoController!.setLooping(true);
    await localVideoController!.initialize();
    localVideoController!.setVolume(0.0);
    localVideoController!.play();
  }
}
