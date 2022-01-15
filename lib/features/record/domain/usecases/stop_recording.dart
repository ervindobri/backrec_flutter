import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/record/domain/repositories/recording_repository.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class StopRecording implements UseCase<XFile, dynamic> {
  final RecordingRepository repository;

  StopRecording(this.repository);

  @override
  Future<Either<Failure, XFile>> call(dynamic params) async {
    return await repository.stopRecording();
  }
}

class Params extends Equatable {
  final String? token;

  Params({required this.token});

  @override
  List<Object?> get props => [token];
}
