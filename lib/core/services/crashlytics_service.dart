import '../logging/app_logger.dart';

abstract class CrashlyticsService {
  void recordError(
    Object exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  });
  void log(String message);
}

class DevCrashlyticsService implements CrashlyticsService {
  DevCrashlyticsService({AppLogger? logger}) : _logger = logger ?? const StandardLogger();

  final AppLogger _logger;

  @override
  void recordError(
    Object exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) {
    _logger.error(
      '💥 [Crashlytics ${fatal ? "FATAL" : "NON-FATAL"}] reason: $reason',
      exception,
      stack,
    );
  }

  @override
  void log(String message) {
    _logger.info('📝 Crashlytics Log: $message');
  }
}
