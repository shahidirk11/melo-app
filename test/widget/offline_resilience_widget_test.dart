import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/core/services/connectivity_service.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/app_settings_repository.dart';
import 'package:melo_app/data/repositories/breathing_pattern_repository.dart';
import 'package:melo_app/data/repositories/mood_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/reminder_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/explore/presentation/explore_screen.dart';
import 'package:melo_app/features/home/presentation/home_screen.dart';
import 'package:melo_app/features/profile/presentation/profile_screen.dart';
import 'package:melo_app/features/progress/presentation/progress_screen.dart';
import 'package:melo_app/features/reminders/presentation/reminders_screen.dart';
import 'package:melo_app/features/sessions/presentation/active_session_screen.dart';
import 'package:melo_app/shared/widgets/melo_button.dart';
import 'package:melo_app/shared/widgets/state_views/error_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Offline-First Screen Resilience & Zero-Network Widget Tests', () {
    late InMemorySessionRepository sessionRepo;
    late InMemoryMoodRepository moodRepo;
    late InMemoryProgressRepository progressRepo;
    late InMemoryUserPreferencesRepository userRepo;
    late InMemoryReminderRepository reminderRepo;
    late InMemoryAppSettingsRepository settingsRepo;
    late InMemoryBreathingPatternRepository breathingRepo;
    late InMemoryAudioService audioService;
    late OfflineFirstConnectivityService connectivityService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      sessionRepo = InMemorySessionRepository(sharedPreferences: prefs);
      moodRepo = InMemoryMoodRepository(sharedPreferences: prefs);
      userRepo = InMemoryUserPreferencesRepository(
        sharedPreferences: prefs,
        initial: const UserPreferences(
          firstName: 'Shahzad',
          onboardingCompleted: true,
          themeMode: AppThemePreference.system,
        ),
      );
      progressRepo = InMemoryProgressRepository(sharedPreferences: prefs);
      reminderRepo = InMemoryReminderRepository(sharedPreferences: prefs);
      settingsRepo = InMemoryAppSettingsRepository(sharedPreferences: prefs);
      breathingRepo = InMemoryBreathingPatternRepository();
      audioService = InMemoryAudioService();
      // Explicitly offline
      connectivityService = OfflineFirstConnectivityService(
        initialStatus: NetworkStatus.offline,
      );
    });

    List<Override> getCommonOverrides() {
      return [
        sessionRepositoryProvider.overrideWithValue(sessionRepo),
        moodRepositoryProvider.overrideWithValue(moodRepo),
        progressRepositoryProvider.overrideWithValue(progressRepo),
        userPreferencesRepositoryProvider.overrideWithValue(userRepo),
        reminderRepositoryProvider.overrideWithValue(reminderRepo),
        appSettingsRepositoryProvider.overrideWithValue(settingsRepo),
        breathingPatternRepositoryProvider.overrideWithValue(breathingRepo),
        audioServiceProvider.overrideWithValue(audioService),
        connectivityServiceProvider.overrideWithValue(connectivityService),
      ];
    }

    Widget createTestApp(Widget homeWidget) {
      return ProviderScope(
        overrides: getCommonOverrides(),
        child: MaterialApp(
          home: Scaffold(
            body: homeWidget,
          ),
        ),
      );
    }

    testWidgets('1. HomeScreen renders completely offline with 0 blank views',
        (tester) async {
      await tester.pumpWidget(createTestApp(const HomeScreen()));
      await tester.pumpAndSettle();

      // No error views
      expect(find.byType(ErrorView), findsNothing);

      // Verify personalized greeting rendered offline
      expect(find.textContaining('Shahzad'), findsOneWidget);

      // Verify mood chips rendered offline
      expect(find.text('😌 Calm'), findsOneWidget);
      expect(find.text('🙂 Good'), findsOneWidget);
      expect(find.text('😐 Okay'), findsOneWidget);
      expect(find.text('😟 Stressed'), findsOneWidget);
      expect(find.text('😴 Tired'), findsOneWidget);

      // Verify Daily Reset card and Quick Resets rendered offline
      expect(find.text('Recommended for you'), findsOneWidget);
      expect(find.text('Quick Resets'), findsOneWidget);
      expect(find.text('Start reset'), findsOneWidget);

      // Interact offline: Tap Stressed mood
      await tester.tap(find.text('😟 Stressed'));
      await tester.pumpAndSettle();

      final latestMood = await moodRepo.getLatestMood();
      expect(latestMood?.type, MoodType.stressed);
    });

    testWidgets('2. ExploreScreen loads starter library and searches/filters offline',
        (tester) async {
      await tester.pumpWidget(createTestApp(const ExploreScreen()));
      await tester.pumpAndSettle();

      // No error view
      expect(find.byType(ErrorView), findsNothing);

      // Verify category tabs exist offline
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Calm'), findsOneWidget);
      expect(find.text('Focus'), findsOneWidget);

      // Verify sessions are listed
      expect(find.text('One Minute Reset'), findsOneWidget);
      expect(find.text('Three Minute Ease'), findsOneWidget);

      // Filter by 1-3 min duration offline
      await tester.tap(find.text('1–3 min'));
      await tester.pumpAndSettle();

      // Verify One Minute Reset is still displayed
      expect(find.text('One Minute Reset'), findsOneWidget);

      // Favorite a session offline
      await tester.tap(find.byIcon(Icons.bookmark_border_rounded).first);
      await tester.pumpAndSettle();

      final favorites = await sessionRepo.getFavorites();
      expect(favorites.length, 1);
    });

    testWidgets('3. ActiveSessionScreen operates offline with breathing animations and seeking',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(const ActiveSessionScreen(sessionId: 'session_1m_reset')),
      );
      await tester.pumpAndSettle();

      // Verify Intro modal displays offline
      expect(find.text('One Minute Reset'), findsOneWidget);
      expect(find.text('Begin reset'), findsOneWidget);

      // Begin session offline
      await tester.tap(find.text('Begin reset'));
      await tester.pumpAndSettle();

      // Check audio status badge shows text/offline mode gracefully
      expect(find.text('Text Guidance'), findsOneWidget);

      // Tap pause offline
      await tester.tap(find.byIcon(Icons.pause_rounded));
      await tester.pump();

      // Tap resume offline
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pump();

      // Tap 10s forward offline
      await tester.tap(find.byIcon(Icons.forward_10_rounded));
      await tester.pump();

      // Tap 10s rewind offline
      await tester.tap(find.byIcon(Icons.replay_10_rounded));
      await tester.pump();
    });

    testWidgets('4. ProgressScreen calculates gentle streaks and history offline',
        (tester) async {
      // Seed a completed record offline
      await progressRepo.recordSession(
        SessionRecord(
          id: 'test_rec_offline_1',
          sessionId: 'session_1m_reset',
          completedAt: DateTime.now(),
          durationSeconds: 60,
          wasCompleted: true,
          initialMood: MoodType.stressed,
          reflectionMood: MoodType.calm,
        ),
      );

      await tester.pumpWidget(createTestApp(const ProgressScreen()));
      await tester.pumpAndSettle();

      // No error view
      expect(find.byType(ErrorView), findsNothing);

      // Verify metrics rendered offline
      expect(find.text('Total Sessions'), findsOneWidget);
      expect(find.text('Mindful Minutes'), findsOneWidget);
      expect(find.text('Active Days'), findsOneWidget);

      // Verify Gentle Streak copy
      expect(find.textContaining('showing up'), findsOneWidget);

      // Verify history list rendered
      expect(find.text('Recent Practice'), findsOneWidget);
      expect(find.text('One Minute Reset'), findsOneWidget);
    });

    testWidgets('5. RemindersScreen renders schedules and explanations offline',
        (tester) async {
      await tester.pumpWidget(createTestApp(const RemindersScreen()));
      await tester.pumpAndSettle();

      // Verify title and daily reminders render offline
      expect(find.text('Gentle Reminders'), findsOneWidget);
      expect(find.text('Morning Intention'), findsOneWidget);
      expect(find.text('Evening Wind Down'), findsOneWidget);

      // Verify pause all toggle is interactive offline
      expect(find.text('Pause all reminders'), findsOneWidget);
    });

    testWidgets('6. ProfileScreen displays offline preferences and data controls',
        (tester) async {
      await tester.pumpWidget(createTestApp(const ProfileScreen()));
      await tester.pumpAndSettle();

      // Verify Profile options
      expect(find.text('Mindfulness Goals'), findsOneWidget);
      expect(find.text('Preferred Duration'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Data & Storage'), findsOneWidget);
      expect(find.text('About Melo'), findsOneWidget);

      // Verify Export Data button is visible offline
      expect(find.text('Export my data'), findsOneWidget);
    });

    testWidgets('7. Connectivity state transitions do not cause blank screens or exceptions',
        (tester) async {
      // Start offline
      expect(connectivityService.isOffline, true);

      await tester.pumpWidget(createTestApp(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Shahzad'), findsOneWidget);

      // Switch to online
      connectivityService.setNetworkStatus(NetworkStatus.online);
      await tester.pumpAndSettle();

      // Still renders perfectly
      expect(find.textContaining('Shahzad'), findsOneWidget);
      expect(find.byType(ErrorView), findsNothing);

      // Switch back to offline
      connectivityService.setNetworkStatus(NetworkStatus.offline);
      await tester.pumpAndSettle();

      // Still renders perfectly
      expect(find.textContaining('Shahzad'), findsOneWidget);
      expect(find.byType(ErrorView), findsNothing);
    });
  });
}
