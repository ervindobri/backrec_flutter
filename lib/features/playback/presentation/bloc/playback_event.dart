part of 'playback_bloc.dart';

@immutable
abstract class PlaybackEvent {}

class InitializePlaybackEvent extends PlaybackEvent {
  final XFile video;
  final bool looping;
  final bool hasVolume;
  InitializePlaybackEvent(this.video, this.looping, this.hasVolume);
}

class InitializeThumbnailEvent extends PlaybackEvent {
  final XFile video;
  InitializeThumbnailEvent(this.video);
}

class StartPlaybackEvent extends PlaybackEvent {}

class StopPlaybackEvent extends PlaybackEvent {}

class SeekPlaybackEvent extends PlaybackEvent {
  final Duration duration;

  SeekPlaybackEvent(this.duration);
}

class PlaybackVolumeEvent extends PlaybackEvent {
  final double volume;
  PlaybackVolumeEvent(this.volume);
}

class DeletePlaybackEvent extends PlaybackEvent {}
