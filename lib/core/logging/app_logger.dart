import 'dart:developer' as developer;

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

abstract class AppLogger {
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message, [Object? error, StackTrace? stackTrace]);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);

  void d(String message, [Object? error, StackTrace? stackTrace]);
  void i(String message, [Object? error, StackTrace? stackTrace]);
  void w(String message, [Object? error, StackTrace? stackTrace]);
  void e(String message, [Object? error, StackTrace? stackTrace]);
}

class StandardLogger implements AppLogger {
  const StandardLogger({this.enabled = true});

  final bool enabled;

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  @override
  void d(String message, [Object? error, StackTrace? stackTrace]) =>
      debug(message, error, stackTrace);

  @override
  void i(String message, [Object? error, StackTrace? stackTrace]) =>
      info(message, error, stackTrace);

  @override
  void w(String message, [Object? error, StackTrace? stackTrace]) =>
      warning(message, error, stackTrace);

  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) =>
      error(message, error, stackTrace);

  void _log(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    if (!enabled) return;
    final prefix = switch (level) {
      LogLevel.debug => '🔍 [DEBUG]',
      LogLevel.info => 'ℹ️ [INFO]',
      LogLevel.warning => '⚠️ [WARN]',
      LogLevel.error => '🛑 [ERROR]',
    };

    developer.log(
      '$prefix $message',
      name: 'Melo',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
