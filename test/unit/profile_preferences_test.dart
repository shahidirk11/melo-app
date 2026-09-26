import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/data/models/app_settings_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/app_settings_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Profile & Settings Unit Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial defaults for UserPreferences and AppSettings', () {
      const prefs = UserPreferences();
      expect(prefs.firstName, '');
      expect(prefs.goals, isEmpty);
      expect(prefs.preferredDurationSeconds, 300);
      expect(prefs.themeMode, AppThemePreference.system);
      expect(prefs.reducedMotion, false);
      expect(prefs.hapticsEnabled, true);

      const settings = AppSettings();
      expect(settings.backgroundAudioEnabled, true);
      expect(settings.offlineAudioCached, false);
      expect(settings.analyticsOptIn, true);
    });

    test('Updates profile preferences and app settings correctly in memory', () async {
      final userRepo = InMemoryUserPreferencesRepository();
      final userNotifier = UserPreferencesNotifier(userRepo);

      final settingsRepo = InMemoryAppSettingsRepository();
      final settingsNotifier = AppSettingsNotifier(settingsRepo);

      // Profile name
      await userNotifier.setFirstName('Maya');
      expect(userNotifier.state.firstName, 'Maya');

      // Mindful goals
      await userNotifier.setGoals(['Feel calmer', 'Build a mindfulness habit']);
      expect(userNotifier.state.goals, ['Feel calmer', 'Build a mindfulness habit']);

      // Preferred duration
      await userNotifier.setPreferredDuration(600);
      expect(userNotifier.state.preferredDurationSeconds, 600);

      // Appearance
      await userNotifier.setTheme(AppThemePreference.dark);
      expect(userNotifier.state.themeMode, AppThemePreference.dark);

      // Accessibility
      await userNotifier.setReducedMotion(true);
      expect(userNotifier.state.reducedMotion, true);

      await userNotifier.setHaptics(false);
      expect(userNotifier.state.hapticsEnabled, false);

      // Audio settings
      await settingsNotifier.setBackgroundAudio(false);
      expect(settingsNotifier.state.backgroundAudioEnabled, false);

      await settingsNotifier.setOfflineAudioCached(true);
      expect(settingsNotifier.state.offlineAudioCached, true);

      // Privacy / Analytics
      await settingsNotifier.setAnalyticsOptIn(false);
      expect(settingsNotifier.state.analyticsOptIn, false);
    });

    test('Persists user preferences across simulated app restarts', () async {
      final sharedPrefs = await SharedPreferences.getInstance();

      // Session 1: User customizes preferences
      final repo1 = InMemoryUserPreferencesRepository(sharedPreferences: sharedPrefs);
      await repo1.setFirstName('Alex');
      await repo1.setGoals(['Improve focus', 'Sleep better']);
      await repo1.setPreferredDuration(900);
      await repo1.setThemePreference(AppThemePreference.light);
      await repo1.setReducedMotion(true);
      await repo1.setHapticsEnabled(false);
      await repo1.setOnboardingCompleted(true);

      // Session 2: App restarts (New repository instance reading same SharedPreferences)
      final repo2 = InMemoryUserPreferencesRepository(sharedPreferences: sharedPrefs);
      final restored = await repo2.getPreferences();

      expect(restored.firstName, 'Alex');
      expect(restored.goals, ['Improve focus', 'Sleep better']);
      expect(restored.preferredDurationSeconds, 900);
      expect(restored.themeMode, AppThemePreference.light);
      expect(restored.reducedMotion, true);
      expect(restored.hapticsEnabled, false);
      expect(restored.onboardingCompleted, true);
    });

    test('Persists app settings across simulated app restarts', () async {
      final sharedPrefs = await SharedPreferences.getInstance();

      // Session 1: User toggles audio & analytics settings
      final repo1 = InMemoryAppSettingsRepository(sharedPreferences: sharedPrefs);
      await repo1.setBackgroundAudioEnabled(false);
      await repo1.setOfflineAudioCached(true);
      await repo1.setAnalyticsOptIn(false);

      // Session 2: App restarts
      final repo2 = InMemoryAppSettingsRepository(sharedPreferences: sharedPrefs);
      final restored = await repo2.getSettings();

      expect(restored.backgroundAudioEnabled, false);
      expect(restored.offlineAudioCached, true);
      expect(restored.analyticsOptIn, false);
    });

    test('Reset to defaults clears custom data and persists default state', () async {
      final sharedPrefs = await SharedPreferences.getInstance();

      final userRepo = InMemoryUserPreferencesRepository(sharedPreferences: sharedPrefs);
      await userRepo.setFirstName('Jordan');
      await userRepo.setGoals(['Take mindful breaks']);
      await userRepo.setThemePreference(AppThemePreference.dark);

      final settingsRepo = InMemoryAppSettingsRepository(sharedPreferences: sharedPrefs);
      await settingsRepo.setBackgroundAudioEnabled(false);

      // Perform reset
      await userRepo.resetToDefaults();
      await settingsRepo.resetToDefaults();

      // Verify immediate state
      final resetUser = await userRepo.getPreferences();
      expect(resetUser.firstName, '');
      expect(resetUser.goals, isEmpty);
      expect(resetUser.themeMode, AppThemePreference.system);

      final resetSettings = await settingsRepo.getSettings();
      expect(resetSettings.backgroundAudioEnabled, true);

      // Verify persistence after restart
      final restartedUserRepo = InMemoryUserPreferencesRepository(sharedPreferences: sharedPrefs);
      final restartedPrefs = await restartedUserRepo.getPreferences();
      expect(restartedPrefs.firstName, '');
      expect(restartedPrefs.goals, isEmpty);
    });
  });
}
