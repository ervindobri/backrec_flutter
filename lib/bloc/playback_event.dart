part of 'playback_bloc.dart';

@immutable
abstract class PlaybackEvent {}

class InitializePlaybackEvent extends PlaybackEvent {
  final XFile video;
  final bool looping;
  final bool hasVolume;
  InitializePlaybackEvent(this.video, this.looping, this.hasVolume);
}

class StartPlaybackEvent extends PlaybackEvent {}

class StopPlaybackEvent extends PlaybackEvent {}

class DeletePlaybackEvent extends PlaybackEvent {}
