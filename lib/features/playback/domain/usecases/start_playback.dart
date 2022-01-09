import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class StartPlayback implements UseCase<String, dynamic> {
  final PlaybackRepository repository;

  StartPlayback(this.repository);

  @override
  Future<Either<Failure, String>> call(dynamic params) async {
    return await repository.startPlayback();
  }
}

class Params extends Equatable {
  final String? token;

  Params(this.token);

  @override
  List<Object?> get props => [token];
}
