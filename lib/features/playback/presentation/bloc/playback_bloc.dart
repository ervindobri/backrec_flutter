import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/init_playback.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/init_thumbnail.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/pause_playback.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/seek_playback.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/start_playback.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

part 'playback_event.dart';
part 'playback_state.dart';

class PlaybackBloc extends Bloc<PlaybackEvent, PlaybackState> {
  final InitializeThumbnail initThumbnail;
  final InitializePlayback initializePlayback;
  final StartPlayback startPlayback;
  final PausePlayback pausePlayback;
  final SeekPlayback seekPlayback;
  PlaybackBloc({
    required this.initThumbnail,
    required this.initializePlayback,
    required this.startPlayback,
    required this.seekPlayback,
    required this.pausePlayback,
  }) : super(PlaybackInitial()) {
    on<PlaybackEvent>((event, emit) async {
      if (event is InitializeThumbnailEvent) {
        print("InitializeThumbnailEvent - ${event.video.name}");
        emit(PlaybackInitializing());
        final result = await initThumbnail(InitParams(event.video));
        emit(result.fold(
          (failure) =>
              PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
          (controller) => ThumbnailInitialized(controller),
        ));
      } else if (event is InitializePlaybackEvent) {
        print("InitializePlaybackEvent - ${event.video.name}");
        emit(PlaybackInitializing());
        final result = await initializePlayback(InitParams(event.video));
        emit(result.fold(
          (failure) =>
              PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
          (controller) => PlaybackInitialized(controller),
        ));
      } else if (event is StartPlaybackEvent) {
        print("StartPlaybackEvent");
        final result = await startPlayback(null);
        emit(result.fold(
          (failure) =>
              PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
          (controller) => PlaybackPlaying(),
        ));
      } else if (event is StopPlaybackEvent) {
        print("StopPlaybackEvent");
        final result = await pausePlayback(null);
        emit(result.fold(
          (failure) =>
              PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
          (controller) => PlaybackStopped(),
        ));
      }
       else if (event is SeekPlaybackEvent) {
        print("SeekPlaybackEvent");
        final result = await seekPlayback(event.duration);
        emit(result.fold(
          (failure) =>
              PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
          (controller) => PlaybackPlaying(),
        ));
      }
      // if (event is InitializePlaybackEvent) {
      //   emit(PlaybackInitializing());
      //   final markers = recordService.markers;
      //   await service.initialize(
      //       markers, event.video, event.looping, event.hasVolume);
      //   emit(PlaybackInitialized());
      // } else if (event is StartPlaybackEvent) {
      //   print("StartPlaybackEvent");
      //   await service.onPlay();
      //   emit(PlaybackPlaying());
      // } else if (event is StopPlaybackEvent) {
      //   print("StopPlaybackEvent");
      //   await service.onPause();
      //   emit(PlaybackStopped());
      // }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case RecordingFailure:
        return (failure as RecordingFailure).message;
      default:
        return failure.toString();
    }
  }
}
