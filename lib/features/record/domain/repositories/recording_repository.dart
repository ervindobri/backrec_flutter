import 'package:backrec_flutter/core/error/failures.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:video_player/video_player.dart';

abstract class RecordingRepository {
  bool recordingStarted = false;
  VideoPlayerController? thumbnailController;

  Future<Either<Failure, String>> startRecording();
  Future<Either<Failure, XFile>> stopRecording();

  Future<Either<Failure, CameraController>> initializeCamera();
  Future<Either<Failure, String>> focusCamera();
}
