import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:video_player/video_player.dart';

abstract class RecordingRepository {
  List<Marker>? markers;
  bool recordingStarted = false;
  VideoPlayerController? thumbnailController;

  Future<Either<Failure, String>> setMarkers(List<Marker> markers);
  Future<Either<Failure, String>> startRecording();
  Future<Either<Failure, String>> stopRecording();

  Future<Either<Failure, CameraController>> initializeCamera();
  Future<Either<Failure, String>> focusCamera();
}
