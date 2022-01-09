import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class PausePlayback implements UseCase<String, dynamic> {
  final PlaybackRepository repository;

  PausePlayback(this.repository);

  @override
  Future<Either<Failure, String>> call(dynamic params) async {
    return await repository.stopPlayback();
  }
}

class Params extends Equatable {
  final String? token;

  Params(this.token);

  @override
  List<Object?> get props => [token];
}
