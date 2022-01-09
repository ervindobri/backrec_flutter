import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/record/domain/repositories/recording_repository.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class InitializeCamera implements UseCase<CameraController, Params> {
  final RecordingRepository repository;

  InitializeCamera(this.repository);

  @override
  Future<Either<Failure, CameraController>> call(Params params) async {
    return await repository.initializeCamera();
  }
}

class Params extends Equatable {
  final String? token;

  Params(this.token);

  @override
  List<Object?> get props => [token];
}
