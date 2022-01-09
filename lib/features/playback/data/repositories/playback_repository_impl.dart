import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/playback/data/datasources/playback_local_datasource.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:video_player/video_player.dart';

typedef Future<String> _UsecaseChooser();
typedef Future<void> _VoidUsecaseChooser();
typedef Future<VideoPlayerController> _InitUsecaseChooser();

class PlaybackRepositoryImpl extends PlaybackRepository {
  final PlaybackLocalDataSource localDataSource;

  PlaybackRepositoryImpl({required this.localDataSource});
  @override
  Future<Either<Failure, String>> setMarkers(List<Marker> markers) async {
    return await _action(() {
      return localDataSource.setMarkers(markers);
    });
  }

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
      XFile video) async {
    return await _initialize(() {
      return localDataSource.initializePlayback(video);
    });
  }

  @override
  Future<Either<Failure, VideoPlayerController>> initializeThumbnail(
      XFile video) async {
    return await _initialize(() {
      return localDataSource.initializeThumbnail(video);
    });
  }

  @override
  Future<Either<Failure, String>> seekPlayback(Duration duration) async{
    return await _action(() {
      return localDataSource.seekPlayback(duration);
    });

  }
}
