import 'dart:typed_data';

import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/playback/data/datasources/playback_local_datasource.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:video_player/video_player.dart';

typedef Future<String> _UsecaseChooser();
typedef Future<Uint8List> _ThumbnailUsecaseChooser();
// typedef Future<void> _VoidUsecaseChooser();
typedef Future<VideoPlayerController> _InitUsecaseChooser();

class PlaybackRepositoryImpl implements PlaybackRepository {
  final PlaybackLocalDataSource localDataSource;

  PlaybackRepositoryImpl({required this.localDataSource});

  Future<Either<Failure, String>> _action(
    _UsecaseChooser getUsecase,
  ) async {
    try {
      final remoteUserInfo = await getUsecase();
      return Right(remoteUserInfo);
    } on CustomServerException catch (e) {
      return Left(CustomServerFailure(e.message));
    } on RedirectException catch (e) {
      return Left(RedirectFailure(e.cause));
    } on RecordingException catch (e) {
      return Left(RecordingFailure(e.message));
    } on PlaybackException catch (e) {
      return Left(PlaybackFailure(e.message));
    }
  }

  Future<Either<Failure, VideoPlayerController>> _initialize(
    _InitUsecaseChooser getUsecase,
  ) async {
    try {
      final localController = await getUsecase();
      // controller = localController;
      return Right(localController);
    } on CustomServerException catch (e) {
      return Left(CustomServerFailure(e.message));
    } on RedirectException catch (e) {
      return Left(RedirectFailure(e.cause));
    } on RecordingException catch (e) {
      return Left(RecordingFailure(e.message));
    } on PlaybackException catch (e) {
      return Left(PlaybackFailure(e.message));
    }
  }

  Future<Either<Failure, Uint8List>> _initializeThumbnail(
    _ThumbnailUsecaseChooser getUsecase,
  ) async {
    try {
      final thumbnail = await getUsecase();
      // controller = localController;
      return Right(thumbnail);
    } on CustomServerException catch (e) {
      return Left(CustomServerFailure(e.message));
    } on RedirectException catch (e) {
      return Left(RedirectFailure(e.cause));
    } on RecordingException catch (e) {
      return Left(RecordingFailure(e.message));
    } on PlaybackException catch (e) {
      return Left(PlaybackFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> startPlayback() async {
    return await _action(() {
      return localDataSource.startPlayback();
    });
  }

  @override
  Future<Either<Failure, String>> stopPlayback() async {
    return await _action(() {
      return localDataSource.stopPlayback();
    });
  }

  @override
  Future<Either<Failure, VideoPlayerController>> initializePlayback(
      String video) async {
    return await _initialize(() {
      // this.video = video;
      this.path = video;
      return localDataSource.initializePlayback(video);
    });
  }

  @override
  Future<Either<Failure, Uint8List>> initializeThumbnail(String video) async {
    return await _initializeThumbnail(() {
      return localDataSource.initializeThumbnail(video);
    });
  }

  @override
  Future<Either<Failure, String>> seekPlayback(Duration duration) async {
    return await _action(() {
      return localDataSource.seekPlayback(duration);
    });
  }

  @override
  late XFile video;

  @override
  Future<Either<Failure, String>> deletePlayback() async {
    return await _action(() {
      return localDataSource.deletePlayback();
    });
  }

  @override
  String get videoNameParsed => localDataSource.videoNameParsed;

  @override
  late String path;
}
