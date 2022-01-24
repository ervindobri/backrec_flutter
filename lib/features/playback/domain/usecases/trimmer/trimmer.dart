import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/trimmer_repository.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class TrimVideo implements UseCase<String, Params> {
  final TrimmerRepository repository;

  TrimVideo(this.repository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await repository.trimVideo(params.videoPath, params.markers);
  }
}

class Params extends Equatable {
  final String videoPath;
  final List<Marker> markers;

  Params({required this.videoPath, required this.markers});

  @override
  List<Object?> get props => [videoPath, markers];
}
