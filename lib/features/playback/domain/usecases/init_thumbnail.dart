import 'dart:typed_data';

import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/core/usecases/usecase.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/init_playback.dart';
import 'package:dartz/dartz.dart';
import 'package:video_player/video_player.dart';

class InitializeThumbnail implements UseCase<Uint8List, InitParams> {
  final PlaybackRepository repository;

  InitializeThumbnail(this.repository);

  @override
  Future<Either<Failure, Uint8List>> call(InitParams params) async {
    return await repository.initializeThumbnail(params.video);
  }
}