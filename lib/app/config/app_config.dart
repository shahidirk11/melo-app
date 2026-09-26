import 'package:flutter/foundation.dart';

enum AppEnvironment {
  development,
  staging,
  production,
}

/// Central configuration for the application.
/// The brand name and product copy are kept configurable here
/// to prevent hard-coding brand strings across business logic.
class AppConfig {
  const AppConfig({
    required this.environment,
    this.appName = 'Melo',
    this.tagline = 'Your little daily reset.',
    this.wellnessDisclaimer =
        'Melo is designed to support daily mindfulness and relaxation. '
        'It is not intended to diagnose, treat, cure, or replace professional '
        'medical or mental health care.',
    this.supportEmail = 'support@melo.app',
    this.enableAnalytics = true,
    this.enableDevLogging = false,
    this.allowTextGuidanceFallback = true,
  });

  final AppEnvironment environment;
  final String appName;
  final String tagline;
  final String wellnessDisclaimer;
  final String supportEmail;
  final bool enableAnalytics;
  final bool enableDevLogging;
  final bool allowTextGuidanceFallback;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isProduction => environment == AppEnvironment.production;

  /// Default configuration for normal app execution.
  static const AppConfig defaultConfig = AppConfig(
    environment: kReleaseMode ? AppEnvironment.production : AppEnvironment.development,
    enableDevLogging: !kReleaseMode,
  );
}
