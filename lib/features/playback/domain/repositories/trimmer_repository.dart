import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:dartz/dartz.dart';

abstract class TrimmerRepository {
  Future<Either<Failure, String>> trimVideo(
      String videoPath, List<Marker> markers);

  Future<void> loadVideo(String videoPath);
  Future<void> createClip(Marker marker);

  Future<bool> isVideoTrimmed(String videoPath);
}
