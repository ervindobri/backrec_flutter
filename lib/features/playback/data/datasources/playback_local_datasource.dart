import 'dart:io';

import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:video_player/video_player.dart';

abstract class PlaybackLocalDataSource {
  List<Marker>? markers;
  VideoPlayerController? thumbnailController;
  VideoPlayerController? controller;

  Future<String> setMarkers(List<Marker> markers);
  Future<String> startPlayback();
  Future<String> stopPlayback();

  Future<VideoPlayerController> initializePlayback(XFile video);
  Future<VideoPlayerController> initializeThumbnail(XFile video);

  Future<String> seekPlayback(Duration duration);
}

class PlaybackLocalDataSourceImpl implements PlaybackLocalDataSource {
  @override
  Future<String> setMarkers(List<Marker> markers) {
    this.markers = markers;
    return Future.value("Markers set successfully");
  }

  @override
  Future<String> startPlayback() async {
    if (controller != null) {
      controller!.play();
      return Future.value("Started");
    }
    throw PlaybackException("Controller is not initialized!");
  }

  @override
  Future<String> stopPlayback() {
    if (controller != null) {
      controller!.pause();
      return Future.value("Started");
    }
    throw PlaybackException("Controller is not initialized!");
  }

  @override
  List<Marker>? markers;

  @override
  VideoPlayerController? controller;

  @override
  VideoPlayerController? thumbnailController;

  @override
  Future<VideoPlayerController> initializePlayback(XFile video) async {
    controller = VideoPlayerController.file(File(video.path));
    await controller?.initialize();
    await controller?.setVolume(1.0);
    await controller?.play();
    return Future.value(controller);
    // return Future.value("Playback controller set successfully");
  }

  @override
  Future<VideoPlayerController> initializeThumbnail(XFile video) async {
    thumbnailController = VideoPlayerController.file(File(video.path));
    await thumbnailController?.initialize();
    await thumbnailController?.setLooping(true);
    await thumbnailController?.setVolume(0.0);
    await thumbnailController?.play();
    return Future.value(thumbnailController!);
    // return Future.value("Thumbnail controller set successfully");
  }

  @override
  Future<String> seekPlayback(Duration duration) {
    if (controller != null) {
      controller!.seekTo(duration);
      if (controller!.value.isPlaying) {
        // controller!.play();

      }
      return Future.value("");
    }
    throw PlaybackException("Controller is not initialized!");
  }
}
