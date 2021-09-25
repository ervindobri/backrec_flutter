part of 'playback_bloc.dart';

@immutable
abstract class PlaybackState {}

class PlaybackInitial extends PlaybackState {}

class PlaybackInitializing extends PlaybackState{}

class PlaybackInitialized extends PlaybackState{}

class PlaybackPlaying extends PlaybackState{}

class PlaybackStopped extends PlaybackState{}

class PlaybackError extends PlaybackState{}
