import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:dartz/dartz.dart';

class DeletePlayback implements UseCase<String, dynamic> {
  final PlaybackRepository repository;

  DeletePlayback(this.repository);

  @override
  Future<Either<Failure, String>> call(dynamic ) async {
    return await repository.deletePlayback();
  }
}

// class Params extends Equatable {
//   final String? token;

//   Params(this.token);

//   @override
//   List<Object?> get props => [token];
// }
