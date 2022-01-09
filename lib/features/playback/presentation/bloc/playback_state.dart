part of 'playback_bloc.dart';

@immutable
abstract class PlaybackState {}

class PlaybackInitial extends PlaybackState {}

class PlaybackInitializing extends PlaybackState {}

class PlaybackInitialized extends PlaybackState {
  final VideoPlayerController controller;

  PlaybackInitialized(this.controller);

}

class ThumbnailInitialized extends PlaybackState {
  final VideoPlayerController controller;

  ThumbnailInitialized(this.controller);
}

class PlaybackPlaying extends PlaybackState {}

class PlaybackStopped extends PlaybackState {}

class PlaybackError extends PlaybackState {
  final String message;

  PlaybackError(this.message);
}
