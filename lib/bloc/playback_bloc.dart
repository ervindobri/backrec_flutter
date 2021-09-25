import 'package:backrec_flutter/services/playback_service.dart';
import 'package:backrec_flutter/services/record_service.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:meta/meta.dart';

part 'playback_event.dart';
part 'playback_state.dart';

class PlaybackBloc extends Bloc<PlaybackEvent, PlaybackState> {
  final PlaybackService service;
  final RecordService recordService;
  PlaybackBloc({required this.service, required this.recordService})
      : super(PlaybackInitial()) {
    on<PlaybackEvent>((event, emit) async {
      if (event is InitializePlaybackEvent) {
        emit(PlaybackInitializing());
        final markers = recordService.markers;
        await service.initialize(
            markers, event.video, event.looping, event.hasVolume);
        emit(PlaybackInitialized());
      } else if (event is StartPlaybackEvent) {
        print("StartPlaybackEvent");
        await service.onPlay();
        emit(PlaybackPlaying());
      } else if (event is StopPlaybackEvent) {
        print("StopPlaybackEvent");
        await service.onPause();
        emit(PlaybackStopped());
      }
    });
  }
}
