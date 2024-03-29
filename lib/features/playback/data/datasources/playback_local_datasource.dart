import 'dart:io';
import 'dart:typed_data';

import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/core/extensions/string_ext.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;

abstract class PlaybackLocalDataSource {
  VideoPlayerController? thumbnailController;
  VideoPlayerController? controller;
  XFile? video;
  String get videoNameParsed => videoPath?.parsed ?? "";
  String? videoPath;

  Future<String> startPlayback();
  Future<String> stopPlayback();

  Future<VideoPlayerController> initializePlayback(String video);
  Future<Uint8List> initializeThumbnail(String video);

  Future<String> seekPlayback(Duration duration);
  Future<String> deletePlayback();
}

class PlaybackLocalDataSourceImpl implements PlaybackLocalDataSource {
  @override
  XFile? video;

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
  VideoPlayerController? controller;

  @override
  VideoPlayerController? thumbnailController;

  @override
  Future<VideoPlayerController> initializePlayback(String video) async {
    try {
      print("Initializing playback for $video");
      controller = VideoPlayerController.file(File(video),
          videoPlayerOptions: VideoPlayerOptions());
      // this.video = video;
      this.videoPath = video;
      await controller?.initialize();
      await controller?.setVolume(1.0);
      await controller?.play();
      return Future.value(controller);
    } catch (e) {
      throw PlaybackException(e.toString());
    }
  }

  @override
  Future<Uint8List> initializeThumbnail(String video) async {
    try {
      print("Initializing thumbnail: $video");
      // thumbnailController = VideoPlayerController.file(File(video));
      // await thumbnailController?.initialize();
      // await thumbnailController?.setLooping(true);
      // await thumbnailController?.setVolume(0.0);
      // await thumbnailController?.play();
      final uint8list = await thumbnail.VideoThumbnail.thumbnailData(
        video: video,
        imageFormat: thumbnail.ImageFormat.PNG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return Future.value(uint8list);
    } catch (e) {
      throw PlaybackException(e.toString());
    }
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

  @override
  Future<String> deletePlayback() async {
    try {
      if (video != null) {
        final path = this.video!.path;
        final galleryVideo = await File(path).delete();
        return Future.value("Video deleted - ${galleryVideo.path}");
      }
      throw PlaybackException("Video data was not loaded.");
    } catch (e) {
      throw PlaybackException("Video couldn't be deleted: $e");
    }
  }

  @override
  String? videoPath;

  @override
  String get videoNameParsed => videoPath?.parsedPath ?? "";
}
