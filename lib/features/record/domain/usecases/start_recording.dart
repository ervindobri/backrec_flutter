import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/record/domain/repositories/recording_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class StartRecording implements UseCase<String, dynamic> {
  final RecordingRepository repository;

  StartRecording(this.repository);

  @override
  Future<Either<Failure, String>> call(dynamic what) async {
    return await repository.startRecording();
  }
}

class Params extends Equatable {

  @override
  List<Object?> get props => [];
}
