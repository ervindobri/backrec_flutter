import 'package:backrec_flutter/core/error/failures.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:video_player/video_player.dart';

abstract class PlaybackRepository {
  late XFile video;
  String get videoNameParsed;
  late String path;
  Future<Either<Failure, String>> startPlayback();
  Future<Either<Failure, String>> stopPlayback();
  Future<Either<Failure, VideoPlayerController>> initializeThumbnail(
      String video);
  Future<Either<Failure, VideoPlayerController>> initializePlayback(
      String video);

  Future<Either<Failure, String>> seekPlayback(Duration params);
  Future<Either<Failure, String>> deletePlayback();
}
