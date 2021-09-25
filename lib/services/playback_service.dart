import 'dart:io';

import 'package:backrec_flutter/models/marker.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlaybackService {
  late XFile video;
  late VideoPlayerController controller;
  late VideoPlayerController localController;
  Duration elapsed = Duration(seconds: 0);
  // final ValueNotifier<Duration> elapsed =
  // ValueNotifier<Duration>(Duration(seconds: 0));
  VoidCallback? videoPlayerListener;
  bool isPlaying = false;
  Duration lastDuration = Duration.zero;
  Duration totalDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  List markers = [];
  // bool get isPlaying => isPlaying.value;

  void initVideoPlayer(XFile video,
      [looping = false, hasVolume = false]) async {
    print("init video player - Getting file: ${video.name}");
    localController = VideoPlayerController.file(File(video.path));
    videoPlayerListener = () {
      // localController.removeListener(videoPlayerListener!);
      elapsed = localController.value.position;
      isPlaying = localController.value.isPlaying;
    };
    localController.addListener(videoPlayerListener!);
    await localController.setLooping(looping);
    await localController.initialize();
    localController.setVolume(hasVolume ? 1.0 : 0.0); //TODO: remove after debug
    // onPlay();
    elapsed = localController.value.position;
  }

  initialize(List recordedMarkers, XFile video,
      [looping = false, hasVolume = false]) {
    initVideoPlayer(video, looping, hasVolume);
    localController.setVolume(1.0);
    markers = recordedMarkers;
    print("Markers: ${markers.length}");
  }

  void onSeek(Duration duration) async {
    // print("Duration: $duration");
    await localController.seekTo(duration);
    lastDuration = duration;
    print(lastDuration);
  }

  Future<void> onPlay() async {
    await localController.play();
    // isPlaying.value = true;
  }

  Future<void> onPause() async {
    await localController.pause();
    // isPlaying.value = false;
  }

  /// Play will resume from beginning of marker.
  void onMarkerTap(Duration position) {
    onSeek(position);
    onPlay();
    print("Marker play: $position");
  }

  /// Find the closest marker end position to the elapsed time, jump to that markers end position
  void jumpToPreviousMarker() {
    if (markers.length > 0) {
      var closest = markers.reduce((a, b) =>
          (a.endPosition.inMilliseconds - elapsed.inMilliseconds).abs() <
                  (b.endPosition.inMilliseconds - elapsed.inMilliseconds).abs()
              ? a
              : b);
      print(closest.startPosition);
      if (closest.endPosition != Duration.zero) {
        onMarkerTap(closest.startPosition);
      }
    }
  }

  /// Find the closest marker end position to the elapsed time, jump to that markers end position
  void jumpToNextMarker() {
    if (markers.length > 0) {
      Marker firstMarker = markers.firstWhere(
          (element) => element.startPosition > elapsed,
          orElse: () => Marker());
      if (firstMarker.endPosition != Duration.zero) {
        onMarkerTap(firstMarker.startPosition);
      }
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
