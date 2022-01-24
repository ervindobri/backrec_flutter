import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CustomServerFailure extends Failure {
  final String message;

  CustomServerFailure(this.message);
}

class CacheFailure extends Failure {}

class RedirectFailure extends Failure {
  final String cause;

  RedirectFailure(this.cause);
}

class ConnectionFailure extends Failure {}

class RecordingFailure extends Failure {
  final String message;

  RecordingFailure(this.message);
}

class PlaybackFailure extends Failure {
  final String message;
  PlaybackFailure(this.message);
}

class TrimmerFailure extends Failure {
  final String message;
  TrimmerFailure(this.message);
}
