import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:video_player/video_player.dart';

abstract class PlaybackRepository {
  List<Marker> markers = [];
  Future<Either<Failure, String>> setMarkers(List<Marker> markers);
  Future<Either<Failure, String>> startPlayback();
  Future<Either<Failure, String>> stopPlayback();
  Future<Either<Failure, VideoPlayerController>> initializeThumbnail(
      XFile video);
  Future<Either<Failure, VideoPlayerController>> initializePlayback(
      XFile video);

  Future<Either<Failure, String>> seekPlayback(Duration params);
}
