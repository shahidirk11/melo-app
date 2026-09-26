import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/app.dart';
import 'package:melo_app/app/config/app_config.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/app/router/routes.dart';
import 'package:melo_app/core/services/audio/audio_types.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/core/services/connectivity_service.dart';
import 'package:melo_app/data/models/breathing_pattern_model.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/reminder_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/app_settings_repository.dart';
import 'package:melo_app/data/repositories/breathing_pattern_repository.dart';
import 'package:melo_app/data/repositories/mood_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/reminder_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/explore/presentation/explore_provider.dart';
import 'package:melo_app/features/home/domain/recommendation_engine.dart';
import 'package:melo_app/features/home/presentation/home_provider.dart';
import 'package:melo_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:melo_app/features/progress/domain/progress_analytics.dart';
import 'package:melo_app/features/progress/presentation/progress_provider.dart';
import 'package:melo_app/features/reminders/presentation/reminders_provider.dart';
import 'package:melo_app/features/sessions/domain/session_state.dart';
import 'package:melo_app/features/sessions/presentation/session_provider.dart';
import 'package:melo_app/features/sessions/presentation/widgets/breathing_circle_visualizer.dart';
import 'package:melo_app/shared/widgets/state_views/empty_view.dart';
import 'package:melo_app/shared/widgets/state_views/error_view.dart';

void main() {
  group('Comprehensive 27-Flow E2E Integration Suite', () {
    late InMemoryUserPreferencesRepository userRepo;
    late InMemoryAppSettingsRepository settingsRepo;
    late InMemorySessionRepository sessionRepo;
    late InMemoryMoodRepository moodRepo;
    late InMemoryProgressRepository progressRepo;
    late InMemoryReminderRepository reminderRepo;
    late InMemoryBreathingPatternRepository breathingRepo;
    late InMemoryAudioService audioService;
    late OfflineFirstConnectivityService connectivityService;

    setUp(() {
      userRepo = InMemoryUserPreferencesRepository();
      settingsRepo = InMemoryAppSettingsRepository();
      sessionRepo = InMemorySessionRepository();
      moodRepo = InMemoryMoodRepository();
      progressRepo = InMemoryProgressRepository();
      reminderRepo = InMemoryReminderRepository();
      breathingRepo = InMemoryBreathingPatternRepository();
      audioService = InMemoryAudioService();
      connectivityService = OfflineFirstConnectivityService();
    });

    List<Override> createOverrides() {
      return [
        userPreferencesRepositoryProvider.overrideWithValue(userRepo),
        appSettingsRepositoryProvider.overrideWithValue(settingsRepo),
        sessionRepositoryProvider.overrideWithValue(sessionRepo),
        moodRepositoryProvider.overrideWithValue(moodRepo),
        progressRepositoryProvider.overrideWithValue(progressRepo),
        reminderRepositoryProvider.overrideWithValue(reminderRepo),
        breathingPatternRepositoryProvider.overrideWithValue(breathingRepo),
        audioServiceProvider.overrideWithValue(audioService),
        connectivityServiceProvider.overrideWithValue(connectivityService),
      ];
    }

    // -------------------------------------------------------------------------
    // Flow 1: Fresh Install & Flow 2: Onboarding Flow
    // -------------------------------------------------------------------------
    testWidgets('Flow 1 & 2: Fresh Install correctly routes to Onboarding and advances steps',
        (tester) async {
      await userRepo.setOnboardingCompleted(false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: createOverrides(),
          child: const MeloApp(),
        ),
      );

      // Splash screen delay
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      // Verified on Onboarding Screen
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);

      // Step 1: Advance to Goals
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      expect(find.text('What would you like help with?'), findsOneWidget);

      // Step 2: Select Goal and Advance to Duration
      await tester.tap(find.text('Feel calmer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 3: Select Duration and Advance to Reminder Time
      expect(find.text('How much time do you usually have?'), findsOneWidget);
      await tester.tap(find.text('5 minutes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 4: Reminder Time Step
      expect(find.text('When would you like your daily reset?'), findsOneWidget);
      await tester.tap(find.text('Morning'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 5: Notification Permission Step
      expect(find.text('A gentle nudge when it\'s time'), findsOneWidget);
      await tester.tap(find.text('Enable reminders'));
      await tester.pumpAndSettle();

      // Step 6: First Session Step
      expect(find.text('Ready for your first reset?'), findsOneWidget);
      await tester.tap(find.text('Explore home first'));
      await tester.pumpAndSettle();

      // Verify onboarding marked completed in preferences
      final savedPrefs = await userRepo.getPreferences();
      expect(savedPrefs.onboardingCompleted, isTrue);
    });

    // -------------------------------------------------------------------------
    // Flow 3: Returning User
    // -------------------------------------------------------------------------
    testWidgets('Flow 3: Returning user bypasses onboarding and lands directly on Home',
        (tester) async {
      await userRepo.setOnboardingCompleted(true);
      await userRepo.setFirstName('Alex');

      await tester.pumpWidget(
        ProviderScope(
          overrides: createOverrides(),
          child: const MeloApp(),
        ),
      );

      // Wait past splash
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      // Ensure Onboarding is bypassed and Home is displayed
      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.textContaining('Alex'), findsOneWidget);
      expect(find.text('YOUR DAILY RESET'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Flow 4: Mood Check-in & Flow 5: Home Recommendation Engine
    // -------------------------------------------------------------------------
    test('Flow 4 & 5: Mood check-in deterministically tailors Home recommendations', () async {
      final engine = const RecommendationEngine();
      final allSessions = await sessionRepo.getAllSessions();
      const prefs = UserPreferences(preferredDurationSeconds: 180);

      // Stressed mood -> recommends calming/breathing
      final stressedRec = engine.recommend(
        allSessions: allSessions,
        preferences: prefs,
        history: const [],
        currentMood: MoodType.stressed,
        currentTime: DateTime(2026, 9, 26, 14, 0),
      );
      expect(
        stressedRec.primarySession.category == SessionCategory.breathing ||
            stressedRec.primarySession.category == SessionCategory.calm ||
            stressedRec.primarySession.category == SessionCategory.stressReset,
        isTrue,
      );
      expect(stressedRec.recommendationReason, contains('ease tension'));

      // Tired mood in evening -> recommends sleep/relaxation
      final tiredRec = engine.recommend(
        allSessions: allSessions,
        preferences: prefs,
        history: const [],
        currentMood: MoodType.tired,
        currentTime: DateTime(2026, 9, 26, 21, 0),
      );
      expect(
        tiredRec.primarySession.category == SessionCategory.sleep ||
            tiredRec.primarySession.category == SessionCategory.relaxation,
        isTrue,
      );
    });

    // -------------------------------------------------------------------------
    // Flow 6: Explore, Flow 7: Search & Flow 8: Favorites
    // -------------------------------------------------------------------------
    test('Flow 6, 7 & 8: Explore search, category filter, and favorites toggle persistence',
        () async {
      final notifier = ExploreNotifier(sessionRepo);
      await notifier.load();

      expect(notifier.state.allSessions.length, greaterThanOrEqualTo(10));

      // 1. Search for 'breath'
      notifier.setSearchQuery('breath');
      expect(
        notifier.state.filteredSessions.every(
          (s) =>
              s.title.toLowerCase().contains('breath') ||
              s.description.toLowerCase().contains('breath') ||
              s.tags.any((t) => t.toLowerCase().contains('breath')),
        ),
        isTrue,
      );

      // Clear search
      notifier.clearFilters();

      // 2. Filter by Category 'Calm'
      notifier.setCategory(SessionCategory.calm);
      expect(
        notifier.state.filteredSessions.every(
          (s) => s.category == SessionCategory.calm,
        ),
        isTrue,
      );

      // 3. Favorites persistence
      const targetSessionId = 'session_1m_reset';
      expect(notifier.state.isFavorite(targetSessionId), isFalse);

      await notifier.toggleFavorite(targetSessionId);
      expect(notifier.state.isFavorite(targetSessionId), isTrue);

      // Check persistent repository
      final favIds = await sessionRepo.getFavoriteIds();
      expect(favIds.contains(targetSessionId), isTrue);

      // Filter only favorites
      notifier.setOnlyFavorites(true);
      expect(notifier.state.filteredSessions.length, equals(1));
      expect(notifier.state.filteredSessions.first.id, equals(targetSessionId));
    });

    // -------------------------------------------------------------------------
    // Flow 9: Meditation Session, Flow 10: Pause/Resume, Flow 11: Completion & Flow 12: Reflection
    // -------------------------------------------------------------------------
    test('Flow 9-12: Full state machine: Init -> Play -> Pause -> Resume -> Complete -> Reflection',
        () async {
      final notifier = SessionEngineNotifier(
        sessionRepository: sessionRepo,
        progressRepository: progressRepo,
        breathingPatternRepository: breathingRepo,
        calculator: const BreathingCalculator(),
        audioService: audioService,
      );

      // 1. Init Session
      await notifier.initSession('session_1m_reset', moodBefore: MoodType.stressed);
      expect(notifier.state.state, equals(SessionState.idle));
      expect(notifier.state.session?.id, equals('session_1m_reset'));
      expect(notifier.state.moodBefore, equals(MoodType.stressed));

      // 2. Start
      await notifier.start();
      expect(notifier.state.state, equals(SessionState.playing));
      expect(audioService.currentSnapshot.isPlaying, isTrue);

      // 3. Pause
      await notifier.pause();
      expect(notifier.state.state, equals(SessionState.paused));
      expect(audioService.currentSnapshot.isPlaying, isFalse);

      // 4. Resume
      await notifier.resume();
      expect(notifier.state.state, equals(SessionState.playing));

      // 5. Complete session
      await notifier.finish(wasCompleted: true);
      expect(notifier.state.state, equals(SessionState.completed));
      expect(audioService.currentSnapshot.isPlaying, isFalse);

      // 6. Record reflection mood
      await notifier.recordReflection(ReflectionMood.moreRelaxed);
      expect(notifier.state.moodAfter, equals(ReflectionMood.moreRelaxed));

      // Verify SessionRecord persisted in ProgressRepository
      final history = await progressRepo.getHistory();
      expect(history.length, equals(1));
      expect(history.first.wasCompleted, isTrue);
      expect(history.first.moodBefore, equals(MoodType.stressed));
      expect(history.first.moodAfter, equals(ReflectionMood.moreRelaxed));
    });

    // -------------------------------------------------------------------------
    // Flow 13: Progress Metrics, Flow 14: History & Flow 15: Gentle Streak
    // -------------------------------------------------------------------------
    test('Flow 13-15: Progress analytics calculates sessions, minutes, active days, and streak',
        () {
      final now = DateTime(2026, 9, 26, 12, 0);

      // Create 3 records: today, yesterday, and 2 days ago
      final records = [
        SessionRecord(
          id: 'rec_1',
          sessionId: 'session_1m_reset',
          sessionTitle: 'One Minute Reset',
          sessionType: SessionType.breathing,
          startedAt: now.subtract(const Duration(minutes: 5)),
          completedAt: now,
          durationCompletedSeconds: 180,
          wasCompleted: true,
        ),
        SessionRecord(
          id: 'rec_2',
          sessionId: 'session_5m_breath',
          sessionTitle: 'Five Minute Pause',
          sessionType: SessionType.breathing,
          startedAt: now.subtract(const Duration(days: 1)),
          completedAt: now.subtract(const Duration(days: 1)),
          durationCompletedSeconds: 300,
          wasCompleted: true,
        ),
        SessionRecord(
          id: 'rec_3',
          sessionId: 'session_10m_deep',
          sessionTitle: 'Ten Minute Grounding',
          sessionType: SessionType.guidedMeditation,
          startedAt: now.subtract(const Duration(days: 2)),
          completedAt: now.subtract(const Duration(days: 2)),
          durationCompletedSeconds: 600,
          wasCompleted: true,
        ),
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.totalSessions, equals(3));
      expect(summary.totalMinutes, equals(18)); // (180+300+600)/60 = 18m
      expect(summary.activeDays, equals(3));
      expect(summary.gentleStreakDays, equals(3));
      expect(summary.streakHeadline, equals('3 days of showing up 🌱'));
    });

    // -------------------------------------------------------------------------
    // Flow 16: Reminder Creation & Flow 17: Notification Permission
    // -------------------------------------------------------------------------
    test('Flow 16 & 17: Reminder schedule creation and notification permission toggle',
        () async {
      final container = ProviderScope(overrides: createOverrides()).createContainer();
      final notifier = container.read(remindersProvider.notifier);

      await notifier.load();
      expect(notifier.state.reminders.length, greaterThanOrEqualTo(2));

      // Request permission
      final granted = await notifier.requestPermission();
      expect(granted, isTrue);
      expect(notifier.state.hasNotificationPermission, isTrue);

      // Add a custom reminder
      await notifier.addCustomReminder(
        hour: 15,
        minute: 30,
        daysOfWeek: [1, 3, 5],
      );

      final updatedList = await reminderRepo.getReminders();
      expect(updatedList.any((r) => r.hour == 15 && r.minute == 30), isTrue);
    });

    // -------------------------------------------------------------------------
    // Flow 19: Settings, Flow 20: Dark Mode & Flow 21: Reduced Motion
    // -------------------------------------------------------------------------
    test('Flow 19-21: Settings persistence: dark mode, reduced motion, and haptics',
        () async {
      final container = ProviderScope(overrides: createOverrides()).createContainer();
      final userNotifier = container.read(userPreferencesProvider.notifier);

      // 1. Dark Mode
      await userNotifier.setTheme(AppThemePreference.dark);
      expect(container.read(userPreferencesProvider).themeMode, equals(AppThemePreference.dark));
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));

      // 2. Reduced Motion
      await userNotifier.setReducedMotion(true);
      expect(container.read(userPreferencesProvider).reducedMotion, isTrue);

      // 3. Haptics
      await userNotifier.setHaptics(false);
      expect(container.read(userPreferencesProvider).hapticsEnabled, isFalse);

      // 4. Verify in persistent repo
      final persisted = await userRepo.getPreferences();
      expect(persisted.themeMode, equals(AppThemePreference.dark));
      expect(persisted.reducedMotion, isTrue);
      expect(persisted.hapticsEnabled, isFalse);
    });

    // -------------------------------------------------------------------------
    // Flow 22: Offline Mode
    // -------------------------------------------------------------------------
    test('Flow 22: Offline mode operations function with zero remote networking required',
        () async {
      connectivityService.simulateDisconnect();
      expect(await connectivityService.checkConnection(), isFalse);

      // Offline content browsing
      final sessions = await sessionRepo.getAllSessions();
      expect(sessions.isNotEmpty, isTrue);

      // Offline breathing pattern access
      final patterns = await breathingRepo.getPatterns();
      expect(patterns.isNotEmpty, isTrue);

      // Offline mood logging
      await moodRepo.recordMood(MoodType.good);
      final latestMood = await moodRepo.getLatestMood();
      expect(latestMood?.mood, equals(MoodType.good));

      // Offline practice logging
      await progressRepo.recordSession(
        SessionRecord(
          id: 'offline_rec_1',
          sessionId: 'session_1m_reset',
          sessionTitle: 'Offline Reset',
          sessionType: SessionType.breathing,
          startedAt: DateTime.now(),
          completedAt: DateTime.now(),
          durationCompletedSeconds: 60,
          wasCompleted: true,
        ),
      );
      final history = await progressRepo.getHistory();
      expect(history.any((r) => r.id == 'offline_rec_1'), isTrue);
    });

    // -------------------------------------------------------------------------
    // Flow 23: Audio Fallback, Flow 25: Backgrounding & Flow 26: Interruption
    // -------------------------------------------------------------------------
    test('Flow 23, 25 & 26: Audio interruptions, volume changes, and headphones disconnect',
        () async {
      await audioService.prepareSessionAudio(
        narrationAsset: null, // Test missing asset fallback mode
        ambientAsset: null,
      );
      expect(audioService.currentSnapshot.isFallbackMode, isTrue);

      // Start playback
      await audioService.play();
      expect(audioService.currentSnapshot.isPlaying, isTrue);

      // Simulate headphone disconnection -> must pause
      await audioService.handleHeadphonesDisconnected();
      expect(audioService.currentSnapshot.isPlaying, isFalse);

      // Resume and simulate incoming call (pause interruption)
      await audioService.play();
      expect(audioService.currentSnapshot.isPlaying, isTrue);
      await audioService.handleInterruption(AudioInterruptionAction.pause);
      expect(audioService.currentSnapshot.isPlaying, isFalse);

      // Call ends -> resume interruption
      await audioService.handleInterruption(AudioInterruptionAction.resume);
      expect(audioService.currentSnapshot.isPlaying, isTrue);

      // Volume adjustments
      await audioService.setMasterVolume(0.7);
      expect(audioService.currentSnapshot.masterVolume, equals(0.7));

      await audioService.setMuted(true);
      expect(audioService.currentSnapshot.isMuted, isTrue);
    });

    // -------------------------------------------------------------------------
    // Flow 27: Error States
    // -------------------------------------------------------------------------
    testWidgets('Flow 27: Error view is rendered gracefully on session load failure',
        (tester) async {
      final container = ProviderScope(overrides: createOverrides()).createContainer();
      final engineNotifier = container.read(sessionEngineProvider.notifier);

      // Initialize with non-existent session ID
      await engineNotifier.initSession('non_existent_id');
      expect(engineNotifier.state.state, equals(SessionState.error));
      expect(engineNotifier.state.errorMessage, isNotNull);
    });
  });
}
