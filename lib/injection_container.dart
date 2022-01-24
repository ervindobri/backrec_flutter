import 'package:backrec_flutter/features/playback/data/datasources/playback_local_datasource.dart';
import 'package:backrec_flutter/features/playback/data/datasources/trimmer_local_datasource.dart';
import 'package:backrec_flutter/features/playback/data/repositories/playback_repository_impl.dart';
import 'package:backrec_flutter/features/playback/data/repositories/trimmer_repository_impl.dart';
import 'package:backrec_flutter/features/playback/domain/entities/ticker.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/trimmer_repository.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/trimmer/trimmer.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/usecases.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/playback/presentation/cubit/trimmer_cubit.dart';
import 'package:backrec_flutter/features/record/data/datasources/markers_local_datasource.dart';
import 'package:backrec_flutter/features/record/data/datasources/recording_local_datasource.dart';
import 'package:backrec_flutter/features/record/data/repositories/marker_repo_impl.dart';
import 'package:backrec_flutter/features/record/data/repositories/recording_repo_impl.dart';
import 'package:backrec_flutter/features/record/domain/repositories/marker_repository.dart';
import 'package:backrec_flutter/features/record/domain/repositories/recording_repository.dart';
import 'package:backrec_flutter/features/record/domain/usecases/init_camera.dart';
import 'package:backrec_flutter/features/record/domain/usecases/start_recording.dart';
import 'package:backrec_flutter/features/record/domain/usecases/stop_recording.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/camera_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/record_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/timer_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //bloc -> usecase -> repo -> datasource
  initCamera();
  initRecordingFeature();
  initPlaybackFeature();
  initTimerFeature();
  initMarkerFeature();
  initTrimmerFeature();
  final sharedPreferences = await SharedPreferences.getInstance();
  final storage = FlutterSecureStorage(
      aOptions: const AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => storage);
  sl.registerLazySingleton(() => http.Client());
}

void initTrimmerFeature() {
  sl.registerFactory(() => TrimmerCubit(repository: sl()));
  sl.registerLazySingleton(() => TrimVideo(sl()));

  sl.registerLazySingleton<TrimmerRepository>(
    () => TrimmerRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<TrimmerLocalDataSource>(
    () => TrimmerLocalDataSourceImpl(),
  );
}

void initMarkerFeature() {
  sl.registerFactory(() => MarkerCubit(repository: sl()));
  sl.registerLazySingleton<MarkerRepository>(
    () => MarkerRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<MarkersLocalDataSource>(
    () => MarkersLocalDataSourceImpl(),
  );
}

void initTimerFeature() {
  sl.registerFactory(() => TimerBloc(ticker: sl()));
  sl.registerLazySingleton(() => Ticker());
}

void initPlaybackFeature() {
  sl.registerFactory(
    () => PlaybackBloc(
        initThumbnail: sl(),
        initializePlayback: sl(),
        pausePlayback: sl(),
        seekPlayback: sl(),
        startPlayback: sl(),
        deletePlayback: sl()),
  );
  sl.registerLazySingleton(() => InitializeThumbnail(sl()));
  sl.registerLazySingleton(() => InitializePlayback(sl()));
  sl.registerLazySingleton(() => PausePlayback(sl()));
  sl.registerLazySingleton(() => StartPlayback(sl()));
  sl.registerLazySingleton(() => SeekPlayback(sl()));
  sl.registerLazySingleton(() => DeletePlayback(sl()));
  sl.registerLazySingleton<PlaybackRepository>(
    () => PlaybackRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<PlaybackLocalDataSource>(
    () => PlaybackLocalDataSourceImpl(),
  );
}

void initCamera() {
  sl.registerFactory(
    () => CameraBloc(
      initializeCamera: sl(),
    ),
  );
  sl.registerLazySingleton(() => InitializeCamera(sl()));
}

void initRecordingFeature() {
  sl.registerFactory(
    () => RecordBloc(
      startRecording: sl(),
      stopRecording: sl(),
    ),
  );
  sl.registerLazySingleton(() => StartRecording(sl()));
  sl.registerLazySingleton(() => StopRecording(sl()));
  sl.registerLazySingleton<RecordingRepository>(
    () => RecordingRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<RecordingLocalDataSource>(
    () => RecordingLocalDataSourceImpl(),
  );
}
