import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:video_player/video_player.dart';

class PlaybackController extends GetxController {
  XFile video;
  late VideoPlayerController localController;
  Rx<Duration> elapsed = Duration(seconds: 0).obs;
  // final ValueNotifier<Duration> elapsed =
  // ValueNotifier<Duration>(Duration(seconds: 0));
  VoidCallback? videoPlayerListener;
  RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;

  PlaybackController({
    required this.video,
    looping = false,
    hasVolume = false,
  }) {
    initVideoPlayer(video, looping, hasVolume);
    elapsed.value = localController.value.position;
  }
  get totalDuration => localController.value.duration;

  @override
  void onInit() {
    super.onInit();
  }

  void initVideoPlayer(XFile video,
      [looping = false, hasVolume = false]) async {
    print("init video player - Getting file: ${video.name}");
    localController = VideoPlayerController.file(File(video.path));
    videoPlayerListener = () {
      // localController.removeListener(videoPlayerListener!);
      elapsed.value = localController.value.position;
    };
    localController.addListener(videoPlayerListener!);
    await localController.setLooping(looping);
    await localController.initialize();
    localController.setVolume(hasVolume ? 1.0 : 0.0); //TODO: remove after debug
    onPlay();
  }

  void onSeek(Duration duration) async {
    // print("Duration: $duration");
    await localController.seekTo(duration);
  }

  void onPlay() async {
    await localController.play();
    _isPlaying.value = true;
  }

  void onPause() async {
    await localController.pause();
    _isPlaying.value = false;
  }

  @override
  void onClose() {
    localController.dispose();
    super.onClose();
  }
}
