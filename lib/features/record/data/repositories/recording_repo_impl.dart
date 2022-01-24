import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/record/data/datasources/recording_local_datasource.dart';
import 'package:backrec_flutter/features/record/domain/repositories/recording_repository.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';

typedef Future<String> _UsecaseChooser();
typedef Future<CameraController> _InitUsecaseChooser();
typedef Future<XFile> _VideoUsecaseChooser();

class RecordingRepositoryImpl extends RecordingRepository {
  final RecordingLocalDataSource localDataSource;
  RecordingRepositoryImpl({required this.localDataSource});

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

  Future<Either<Failure, XFile>> _video(
    _VideoUsecaseChooser getUsecase,
  ) async {
    try {
      final localVideo = await getUsecase();
      return Right(localVideo);
    } on CustomServerException catch (e) {
      return Left(CustomServerFailure(e.message));
    } on RedirectException catch (e) {
      return Left(RedirectFailure(e.cause));
    } on RecordingException catch (e) {
      return Left(RecordingFailure(e.message));
    }
  }

  Future<Either<Failure, CameraController>> _initialize(
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
  Future<Either<Failure, String>> startRecording() async {
    return await _action(() {
      recordingStarted = true;
      return localDataSource.startRecording();
    });
  }

  @override
  Future<Either<Failure, XFile>> stopRecording() async {
    return await _video(() {
      recordingStarted = false;
      return localDataSource.stopRecording();
    });
  }

  @override
  Future<Either<Failure, String>> focusCamera() async {
    return await _action(() {
      return localDataSource.focusCamera();
    });
  }

  @override
  Future<Either<Failure, CameraController>> initializeCamera() async {
    return await _initialize(() {
      return localDataSource.initializeCamera();
    });
  }
}
