import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/logging/app_logger.dart';
import '../core/services/analytics_service.dart';
import '../core/services/audio/audio_service.dart';
import '../core/services/audio/just_audio_service.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/crashlytics_service.dart';
import '../core/services/notification_service.dart';
import '../data/database/database.dart';
import '../data/models/user_preferences_model.dart';
import '../data/repositories/app_settings_repository.dart';
import '../data/repositories/breathing_pattern_repository.dart';
import '../data/repositories/mood_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/reminder_repository.dart';
import '../data/repositories/session_repository.dart';
import '../data/repositories/user_preferences_repository.dart';
import 'config/app_config.dart';

// --- CONFIGURATION & LOGGING PROVIDERS ---

final configProvider = Provider<AppConfig>((ref) {
  return AppConfig.defaultConfig;
});

final loggerProvider = Provider<AppLogger>((ref) {
  final config = ref.watch(configProvider);
  return StandardLogger(enabled: config.enableDevLogging);
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final logger = ref.watch(loggerProvider);
  return DevAnalyticsService(logger: logger);
});

final crashlyticsServiceProvider = Provider<CrashlyticsService>((ref) {
  final logger = ref.watch(loggerProvider);
  return DevCrashlyticsService(logger: logger);
});

// --- REPOSITORY PROVIDERS ---

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return InMemorySessionRepository();
});

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return InMemoryMoodRepository();
});

final userPreferencesRepositoryProvider = Provider<UserPreferencesRepository>((ref) {
  return InMemoryUserPreferencesRepository();
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return InMemoryProgressRepository();
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return InMemoryReminderRepository();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return LocalNotificationService();
});

final breathingPatternRepositoryProvider = Provider<BreathingPatternRepository>((ref) {
  return InMemoryBreathingPatternRepository();
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return InMemoryAppSettingsRepository();
});

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = JustAudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = OfflineFirstConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final networkStatusProvider = StreamProvider<NetworkStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
});

// --- REACTIVE STATE NOTIFIERS ---

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier(this._repository) : super(const UserPreferences()) {
    _load();
  }

  final UserPreferencesRepository _repository;

  Future<void> _load() async {
    final prefs = await _repository.getPreferences();
    state = prefs;
  }

  Future<void> updatePreferences(UserPreferences updated) async {
    await _repository.updatePreferences(updated);
    state = updated;
  }

  Future<void> setGoals(List<String> goals) async {
    final updated = state.copyWith(goals: goals);
    await _repository.updatePreferences(updated);
    state = updated;
  }

  Future<void> setPreferredDuration(int durationSeconds) async {
    final updated = state.copyWith(preferredDurationSeconds: durationSeconds);
    await _repository.updatePreferences(updated);
    state = updated;
  }

  Future<void> setPreferredTimeOfDay(
    TimeOfDayPreference timeOfDay, {
    int? customHour,
    int? customMinute,
  }) async {
    final updated = state.copyWith(
      preferredTimeOfDay: timeOfDay,
      customReminderHour: customHour ?? state.customReminderHour,
      customReminderMinute: customMinute ?? state.customReminderMinute,
    );
    await _repository.updatePreferences(updated);
    state = updated;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final updated = state.copyWith(notificationsEnabled: enabled);
    await _repository.updatePreferences(updated);
    state = updated;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _repository.setOnboardingCompleted(completed);
    state = state.copyWith(onboardingCompleted: completed);
  }

  Future<void> setTheme(AppThemePreference theme) async {
    await _repository.setThemePreference(theme);
    state = state.copyWith(themeMode: theme);
  }

  Future<void> setReducedMotion(bool enabled) async {
    await _repository.setReducedMotion(enabled);
    state = state.copyWith(reducedMotion: enabled);
  }

  Future<void> setHaptics(bool enabled) async {
    await _repository.setHapticsEnabled(enabled);
    state = state.copyWith(hapticsEnabled: enabled);
  }

  Future<void> setFirstName(String name) async {
    final updated = state.copyWith(firstName: name);
    await _repository.updatePreferences(updated);
    state = updated;
  }

  Future<void> resetToDefaults() async {
    await _repository.resetToDefaults();
    state = const UserPreferences();
  }
}

final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  final repo = ref.watch(userPreferencesRepositoryProvider);
  return UserPreferencesNotifier(repo);
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final prefs = ref.watch(userPreferencesProvider);
  return switch (prefs.themeMode) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier(this._repository) : super(const AppSettings()) {
    _load();
  }

  final AppSettingsRepository _repository;

  Future<void> _load() async {
    final settings = await _repository.getSettings();
    state = settings;
  }

  Future<void> setBackgroundAudio(bool enabled) async {
    await _repository.setBackgroundAudioEnabled(enabled);
    state = state.copyWith(backgroundAudioEnabled: enabled);
  }

  Future<void> setOfflineAudioCached(bool cached) async {
    await _repository.setOfflineAudioCached(cached);
    state = state.copyWith(offlineAudioCached: cached);
  }

  Future<void> setAnalyticsOptIn(bool optIn) async {
    await _repository.setAnalyticsOptIn(optIn);
    state = state.copyWith(analyticsOptIn: optIn);
  }

  Future<void> resetToDefaults() async {
    await _repository.resetToDefaults();
    state = const AppSettings();
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final repo = ref.watch(appSettingsRepositoryProvider);
  return AppSettingsNotifier(repo);
});
