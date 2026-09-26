import '../logging/app_logger.dart';

abstract class AnalyticsService {
  void logEvent(String name, [Map<String, Object>? parameters]);
  void logScreen(String screenName);
}

class DevAnalyticsService implements AnalyticsService {
  DevAnalyticsService({AppLogger? logger}) : _logger = logger ?? const StandardLogger();

  final AppLogger _logger;

  @override
  void logEvent(String name, [Map<String, Object>? parameters]) {
    _logger.debug('📊 Analytics Event: $name | params: $parameters');
  }

  @override
  void logScreen(String screenName) {
    _logger.debug('📱 Screen View: $screenName');
  }
}
