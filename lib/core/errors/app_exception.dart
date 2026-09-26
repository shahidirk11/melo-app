/// Base class for all domain and infrastructure exceptions within Melo.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause, super.stackTrace});
}

class AudioPlaybackException extends AppException {
  const AudioPlaybackException(super.message, {super.cause, super.stackTrace});
}

class NotificationException extends AppException {
  const NotificationException(super.message, {super.cause, super.stackTrace});
}

class ContentNotFoundException extends AppException {
  const ContentNotFoundException(super.message, {super.cause, super.stackTrace});
}

class PreferencesException extends AppException {
  const PreferencesException(super.message, {super.cause, super.stackTrace});
}

class PermissionDeniedException extends AppException {
  const PermissionDeniedException(super.message, {super.cause, super.stackTrace});
}
