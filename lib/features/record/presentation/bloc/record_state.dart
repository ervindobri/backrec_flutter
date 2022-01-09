part of 'record_bloc.dart';

@immutable
abstract class RecordState {}

class RecordingInitial extends RecordState {}

class RecordingLoading extends RecordState {} //delay

class RecordingStarted extends RecordState {
  final String message;

  RecordingStarted(this.message);
}

class RecordingStopped extends RecordState {
  final String message;

  RecordingStopped(this.message);
}

class RecordingError extends RecordState {
  final String message;

  RecordingError(this.message);
}
