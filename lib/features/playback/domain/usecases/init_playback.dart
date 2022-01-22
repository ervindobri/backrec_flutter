import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

class InitializePlayback implements UseCase<VideoPlayerController, InitParams> {
  final PlaybackRepository repository;

  InitializePlayback(this.repository);

  @override
  Future<Either<Failure, VideoPlayerController>> call(InitParams params) async {
    return await repository.initializePlayback(params.video);
  }
}

class InitParams extends Equatable {
  // final XFile video;
  final String video;

  InitParams(this.video);

  @override
  List<Object?> get props => [video];
}
