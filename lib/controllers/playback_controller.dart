import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import 'package:backrec_flutter/models/marker.dart';
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

  Duration lastDuration = Duration.zero;

  Duration currentPosition = Duration.zero;

  RxList markers = [].obs;
  bool get isPlaying => _isPlaying.value;

  PlaybackController({
    required this.video,
    looping = false,
    hasVolume = false,
  }) {
    initVideoPlayer(video, looping, hasVolume);
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
    elapsed.value = localController.value.position;
  }

  void onSeek(Duration duration) async {
    // print("Duration: $duration");
    await localController.seekTo(duration);
    lastDuration = duration;
    print(lastDuration);
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

  /// Play will resume from beginning of marker.
  void onMarkerTap(Duration position) {
    onSeek(position);
    onPlay();
    print("Marker play: $position");
  }

  /// Find the closest marker end position to the elapsed time, jump to that markers end position
  void jumpToPreviousMarker() {
    var closest = markers.reduce((a, b) =>
        (a.endPosition.inMilliseconds - elapsed.value.inMilliseconds).abs() <
                (b.endPosition.inMilliseconds - elapsed.value.inMilliseconds)
                    .abs()
            ? a
            : b);
    print(closest.startPosition);
    if (closest.endPosition != Duration.zero) {
      onMarkerTap(closest.startPosition);
    }
  }

  /// Find the closest marker end position to the elapsed time, jump to that markers end position
  void jumpToNextMarker() {
    Marker firstMarker = markers.firstWhere(
        (element) => element.startPosition > elapsed.value,
        orElse: () => Marker());
    if (firstMarker.endPosition != Duration.zero) {
      onMarkerTap(firstMarker.startPosition);
    }
  }

  /// Playback jumping from marker to marker
  void markerPlayback() {
    //TODO: play videos jumping from marker to marker
  }

  void saveMarker(Marker marker) {
    markers.add(marker);
  }
}
