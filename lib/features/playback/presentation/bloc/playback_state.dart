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
  final Uint8List thumbnail;

  ThumbnailInitialized(this.thumbnail);
}

class PlaybackPlaying extends PlaybackState {}

class PlaybackStopped extends PlaybackState {}

class PlaybackDeleted extends PlaybackState {}

class PlaybackError extends PlaybackState {
  final String message;

  PlaybackError(this.message);
}

class MarkerPlayback extends PlaybackState {
  final Marker marker;

  MarkerPlayback(this.marker);
}
