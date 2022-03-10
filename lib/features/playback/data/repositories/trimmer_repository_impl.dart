import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/playback/data/datasources/trimmer_local_datasource.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/trimmer_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';

typedef Future<String> _UsecaseChooser();

class TrimmerRepositoryImpl extends TrimmerRepository {
  final TrimmerLocalDataSource localDataSource;
  TrimmerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, String>> trimVideo(
      String videoPath, List<Marker> markers) async {
    return await _action(() {
      return localDataSource.trimVideo(videoPath, markers);
    });
  }

  Future<Either<Failure, String>> _action(
    _UsecaseChooser getUsecase,
  ) async {
    try {
      final localTrimmer = await getUsecase();
      return Right(localTrimmer);
    } on CustomServerException catch (e) {
      return Left(CustomServerFailure(e.message));
    } on TrimmerFailure catch (e) {
      return Left(TrimmerFailure(e.message));
    }
  }

  @override
  Future<void> createClip(Marker marker) async {
    await localDataSource.createClip(marker);
  }

  @override
  Future<void> loadVideo(String videoPath) async {
        await localDataSource.loadVideo(videoPath);

  }

  @override
  Future<bool> isVideoTrimmed(String videoPath) {
    // TODO: implement isVideoTrimmed
    throw UnimplementedError();
  }
}
