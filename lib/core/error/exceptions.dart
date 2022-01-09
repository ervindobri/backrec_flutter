class ServerException implements Exception {}

class CustomServerException implements Exception {
  String message;

  CustomServerException(this.message);
}

class CacheException implements Exception {}

class RedirectException implements Exception {
  final String cause;

  RedirectException(this.cause);
}

class RecordingException implements Exception {
  final String message;

  RecordingException(this.message);
}

class PlaybackException implements Exception {
  final String message;

  PlaybackException(this.message);
}
