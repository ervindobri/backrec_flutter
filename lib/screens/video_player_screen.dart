import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoPlayerScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController localController;

  @override
  void initState() {
    localController = widget.controller;
    super.initState();
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
              color: GlobalColors.primaryGrey.withOpacity(.4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(FeatherIcons.arrowLeft, color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
