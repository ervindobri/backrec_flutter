import 'dart:typed_data';

import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/delete_playback.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/init_playback.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/init_thumbnail.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/pause_playback.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/seek_playback.dart';
import 'package:backrec_flutter/features/playback/domain/usecases/start_playback.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
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
  final DeletePlayback deletePlayback;

  PlaybackBloc({
    required this.initThumbnail,
    required this.initializePlayback,
    required this.startPlayback,
    required this.seekPlayback,
    required this.deletePlayback,
    required this.pausePlayback,
  }) : super(PlaybackInitial()) {
    on<PlaybackEvent>((event, emit) async {
      if (event is InitializeThumbnailEvent) {
        print("InitializeThumbnailEvent - ${event.video?.name}");
        print("${event.video?.path}, ${event.videoPath}");
        // emit(PlaybackInitializing());
        final result = await initThumbnail(InitParams(event.video?.path ?? event.videoPath!));
        emit(result.fold(
          (failure) =>
              PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
          (thumbnail) => ThumbnailInitialized(thumbnail),
        ));
      } else if (event is InitializePlaybackEvent) {
        print("InitializePlaybackEvent - ${event.video}");
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
      } else if (event is SeekPlaybackEvent) {
        print("SeekPlaybackEvent");
        final result = await seekPlayback(event.duration);
        add(StartPlaybackEvent());
        emit(result.fold(
          (failure) =>
              PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
          (controller) => PlaybackPlaying(),
        ));
      } else if (event is DeletePlaybackEvent) {
        print("DeletePlaybackEvent");
        final result = await deletePlayback(null);
        emit(result.fold(
          (failure) =>
              PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
          (controller) => PlaybackDeleted(),
        ));
      } else if (event is MarkerPlaybackEvent) {
        print("MarkerPlaybackEvent");
        add(StartPlaybackEvent());
        event.markers
            .sort((a, b) => a.startPosition.compareTo(b.startPosition));
        final sortedMarkers = event.markers;
        for (var marker in sortedMarkers) {
          final result = await seekPlayback(marker.startPosition);
          emit(result.fold(
            (failure) =>
                PlaybackError(_mapFailureToMessage(failure)), //todo: map errors
            (controller) => MarkerPlayback(marker),
          ));
          //wait clipLength before next clip
          await Future.delayed(Duration(seconds: 12, milliseconds: 500));
        }
        add(StopPlaybackEvent());
      } else {
        //other event
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case RecordingFailure:
        return (failure as RecordingFailure).message;
      case PlaybackFailure:
        return (failure as PlaybackFailure).message;
      default:
        return failure.toString();
    }
  }
}
