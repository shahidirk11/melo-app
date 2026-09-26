import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/config/app_config.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/data/models/app_settings_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/app_settings_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/profile/presentation/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestWidget({
    UserPreferences? initialUserPrefs,
    AppSettings? initialSettings,
    UserPreferencesRepository? userRepo,
    AppSettingsRepository? settingsRepo,
    ProgressRepository? progressRepo,
  }) {
    final uRepo = userRepo ??
        InMemoryUserPreferencesRepository(initial: initialUserPrefs);
    final sRepo = settingsRepo ??
        InMemoryAppSettingsRepository(initialSettings: initialSettings);
    final pRepo = progressRepo ?? InMemoryProgressRepository();

    return ProviderScope(
      overrides: [
        userPreferencesRepositoryProvider.overrideWithValue(uRepo),
        appSettingsRepositoryProvider.overrideWithValue(sRepo),
        progressRepositoryProvider.overrideWithValue(pRepo),
        configProvider.overrideWithValue(
          const AppConfig(
            appName: 'Melo',
            appVersion: '1.0.0',
            environment: AppEnvironment.production,
            tagline: 'A quiet space for mind and body',
            wellnessDisclaimer:
                'Melo is a wellness and mindfulness companion, not clinical software or medical treatment.',
          ),
        ),
      ],
      child: const MaterialApp(
        home: ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen Widget Tests', () {
    testWidgets('Renders all primary sections, headers, and controls',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Header & Profile card
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Mindful Practicioner'), findsOneWidget);
      expect(find.text('0 mindful resets · 0m quiet time'), findsOneWidget);

      // Section headers (eyebrows or titles)
      expect(find.text('PRACTICE'), findsOneWidget);
      expect(find.text('SOUND'), findsOneWidget);
      expect(find.text('APPEARANCE'), findsOneWidget);
      expect(find.text('COMFORT'), findsOneWidget);

      // Mindfulness preferences
      expect(find.text('Mindful Goals'), findsOneWidget);
      expect(find.text('Preferred Session Length'), findsOneWidget);
      expect(find.text('Reminder Schedule'), findsOneWidget);

      // Audio settings
      expect(find.text('Background audio playback'), findsOneWidget);
      expect(find.text('Offline audio caching'), findsOneWidget);

      // Appearance options
      expect(find.text('System default'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      // Accessibility & Comfort
      expect(find.text('Reduced motion'), findsOneWidget);
      expect(find.text('Gentle haptics'), findsOneWidget);
      expect(find.text('Text Scaling Compatible'), findsOneWidget);

      // Scroll to view bottom sections
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Privacy, Data & About
      expect(find.text('100% Local-First Storage'), findsOneWidget);
      expect(find.text('Anonymous diagnostics'), findsOneWidget);
      expect(find.text('Export Data'), findsOneWidget);
      expect(find.text('Clear Data'), findsOneWidget);
      expect(find.text('About Melo & Open Source Licenses'), findsOneWidget);
    });

    testWidgets('Editing name updates displayed name immediately',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap edit name button
      await tester.tap(find.byTooltip('Edit name'));
      await tester.pumpAndSettle();

      // Verify edit dialog is open
      expect(find.text('Your Name'), findsOneWidget);

      // Enter new name
      await tester.enterText(find.byType(TextField), 'Sophia');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Check updated name
      expect(find.text('Sophia'), findsOneWidget);
    });

    testWidgets('Theme selection updates theme mode', (tester) async {
      final userRepo = InMemoryUserPreferencesRepository();
      await tester.pumpWidget(buildTestWidget(userRepo: userRepo));
      await tester.pumpAndSettle();

      // Tap Dark
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      final updatedToDark = await userRepo.getPreferences();
      expect(updatedToDark.themeMode, AppThemePreference.dark);

      // Tap Light
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      final updatedToLight = await userRepo.getPreferences();
      expect(updatedToLight.themeMode, AppThemePreference.light);
    });

    testWidgets('Accessibility toggles update motion and haptics preferences',
        (tester) async {
      final userRepo = InMemoryUserPreferencesRepository();
      await tester.pumpWidget(buildTestWidget(userRepo: userRepo));
      await tester.pumpAndSettle();

      // Toggle Reduced Motion
      await tester.tap(find.widgetWithText(SwitchListTile, 'Reduced motion'));
      await tester.pumpAndSettle();

      var prefs = await userRepo.getPreferences();
      expect(prefs.reducedMotion, true);

      // Toggle Gentle Haptics
      await tester.tap(find.widgetWithText(SwitchListTile, 'Gentle haptics'));
      await tester.pumpAndSettle();

      prefs = await userRepo.getPreferences();
      expect(prefs.hapticsEnabled, false);
    });

    testWidgets('Audio settings toggles update AppSettings repository',
        (tester) async {
      final settingsRepo = InMemoryAppSettingsRepository();
      await tester.pumpWidget(buildTestWidget(settingsRepo: settingsRepo));
      await tester.pumpAndSettle();

      // Toggle Background Audio
      await tester.tap(find.widgetWithText(SwitchListTile, 'Background audio playback'));
      await tester.pumpAndSettle();

      var settings = await settingsRepo.getSettings();
      expect(settings.backgroundAudioEnabled, false);

      // Toggle Offline Audio
      await tester.tap(find.widgetWithText(SwitchListTile, 'Offline audio caching'));
      await tester.pumpAndSettle();

      settings = await settingsRepo.getSettings();
      expect(settings.offlineAudioCached, true);
    });

    testWidgets('Goals modal opens, allows selection, and saves',
        (tester) async {
      final userRepo = InMemoryUserPreferencesRepository();
      await tester.pumpWidget(buildTestWidget(userRepo: userRepo));
      await tester.pumpAndSettle();

      // Tap Mindful Goals tile
      await tester.tap(find.text('Mindful Goals'));
      await tester.pumpAndSettle();

      // Verify modal is open
      expect(find.text('Your Mindful Goals'), findsOneWidget);
      expect(find.text('Save Goals'), findsOneWidget);

      // Select 'Feel calmer' and 'Improve focus'
      await tester.tap(find.text('Feel calmer'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Improve focus'));
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Save Goals'));
      await tester.pumpAndSettle();

      // Modal closed, goals saved
      final prefs = await userRepo.getPreferences();
      expect(prefs.goals, contains('Feel calmer'));
      expect(prefs.goals, contains('Improve focus'));
    });

    testWidgets('Preferred duration modal opens, allows selection, and saves',
        (tester) async {
      final userRepo = InMemoryUserPreferencesRepository();
      await tester.pumpWidget(buildTestWidget(userRepo: userRepo));
      await tester.pumpAndSettle();

      // Tap Preferred Session Length tile
      await tester.tap(find.text('Preferred Session Length'));
      await tester.pumpAndSettle();

      // Verify modal is open
      expect(find.text('10 min'), findsOneWidget);
      expect(find.text('Save Session Length'), findsOneWidget);

      // Tap 10 min option
      await tester.tap(find.text('10 min'));
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Save Session Length'));
      await tester.pumpAndSettle();

      final prefs = await userRepo.getPreferences();
      expect(prefs.preferredDurationSeconds, 600);
    });

    testWidgets('Privacy details modal opens and displays wellness notice',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Scroll to privacy section
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap Privacy & Wellness Details tile
      await tester.tap(find.text('Privacy & Wellness Details'));
      await tester.pumpAndSettle();

      // Verify modal content
      expect(find.text('Privacy & Data Care'), findsOneWidget);
      expect(find.text('100% Local-First Storage'), findsWidgets);
      expect(find.text('Wellness Notice'), findsOneWidget);
    });

    testWidgets('Data export modal opens and shows export JSON preview',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Scroll to data section
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap Export Data button
      await tester.tap(find.text('Export Data'));
      await tester.pumpAndSettle();

      // Verify export modal
      expect(find.text('Export Your Data'), findsOneWidget);
      expect(find.text('Copy JSON to Clipboard'), findsOneWidget);
      expect(find.text('Mindful Time'), findsOneWidget);
    });

    testWidgets('Clear data button triggers confirmation dialog and resets',
        (tester) async {
      final userRepo = InMemoryUserPreferencesRepository(
        initial: const UserPreferences(firstName: 'Charlie'),
      );
      final settingsRepo = InMemoryAppSettingsRepository();

      await tester.pumpWidget(buildTestWidget(
        userRepo: userRepo,
        settingsRepo: settingsRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Charlie'), findsOneWidget);

      // Scroll to data section
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap Clear Data button
      await tester.tap(find.text('Clear Data'));
      await tester.pumpAndSettle();

      // Verify destructive confirmation dialog
      expect(find.text('Reset all app data?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Reset Everything'), findsOneWidget);

      // Tap Cancel first: verify data was NOT cleared
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Reset all app data?'), findsNothing);
      var prefs = await userRepo.getPreferences();
      expect(prefs.firstName, 'Charlie');

      // Tap Clear Data again, then confirm Reset Everything
      await tester.tap(find.text('Clear Data'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reset Everything'));
      await tester.pumpAndSettle();

      // Verify reset state
      prefs = await userRepo.getPreferences();
      expect(prefs.firstName, '');
    });

    testWidgets('About Melo modal opens and displays app info and principles',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Scroll to bottom
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Tap About Melo & Open Source Licenses button
      await tester.tap(find.text('About Melo & Open Source Licenses'));
      await tester.pumpAndSettle();

      // Verify about modal
      expect(find.text('About Melo'), findsWidgets);
      expect(find.text('Our Philosophy'), findsOneWidget);
      expect(find.text('Version 1.0.0 (Build 1)'), findsOneWidget);
      expect(find.text('View Open Source Licenses'), findsOneWidget);
    });
  });
}
