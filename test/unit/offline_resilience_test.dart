import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/core/services/connectivity_service.dart';
import 'package:melo_app/data/datasources/local_content_seed.dart';
import 'package:melo_app/data/models/app_settings_model.dart';
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
import 'package:melo_app/features/home/domain/recommendation_engine.dart';
import 'package:melo_app/features/sessions/domain/breathing_calculator.dart';
import 'package:melo_app/features/sessions/domain/session_state.dart';
import 'package:melo_app/features/sessions/presentation/session_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Offline-First Reliability & Resilience Pass', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Fresh install initializes all bundled content and local repositories with 0 internet', () async {
      final sharedPrefs = await SharedPreferences.getInstance();

      final sessionRepo = InMemorySessionRepository(sharedPreferences: sharedPrefs);
      final userRepo = InMemoryUserPreferencesRepository(sharedPreferences: sharedPrefs);
      final settingsRepo = InMemoryAppSettingsRepository(sharedPreferences: sharedPrefs);
      final progressRepo = InMemoryProgressRepository(sharedPreferences: sharedPrefs);
      final moodRepo = InMemoryMoodRepository(sharedPreferences: sharedPrefs);
      final reminderRepo = InMemoryReminderRepository(sharedPreferences: sharedPrefs);
      final breathingRepo = InMemoryBreathingPatternRepository();

      // 1. Bundled content is 100% available
      final allSessions = await sessionRepo.getAllSessions();
      expect(allSessions.length, greaterThanOrEqualTo(16));
      expect(allSessions.any((s) => s.durationSeconds == 60), true);
      expect(allSessions.any((s) => s.durationSeconds == 300), true);
      expect(allSessions.any((s) => s.durationSeconds == 600), true);

      // All 8 categories available
      for (final cat in SessionCategory.values) {
        final matches = await sessionRepo.getSessionsByCategory(cat);
        expect(matches.isNotEmpty, true, reason: 'Category ${cat.displayName} missing');
      }

      // 2. Preferences defaults
      final prefs = await userRepo.getPreferences();
      expect(prefs.onboardingCompleted, false);
      expect(prefs.themeMode, AppThemePreference.system);
      expect(prefs.goals, isEmpty);

      // 3. Settings defaults
      final settings = await settingsRepo.getSettings();
      expect(settings.offlineAudioCached, false);
      expect(settings.backgroundAudioEnabled, true);

      // 4. Progress and Moods initially empty
      final history = await progressRepo.getHistory();
      expect(history, isEmpty);

      final latestMood = await moodRepo.getLatestMood();
      expect(latestMood, isNull);

      // 5. Default reminders seeded
      final reminders = await reminderRepo.getReminders();
      expect(reminders.length, greaterThanOrEqualTo(2));

      // 6. Breathing patterns available
      final patterns = await breathingRepo.getAllPatterns();
      expect(patterns.length, 3);
    });

    test('Full data persistence survives simulated app restart across all domains', () async {
      final sharedPrefs = await SharedPreferences.getInstance();

      // --- SESSION 1: User practices offline ---
      final sessionRepo1 = InMemorySessionRepository(sharedPreferences: sharedPrefs);
      final userRepo1 = InMemoryUserPreferencesRepository(sharedPreferences: sharedPrefs);
      final settingsRepo1 = InMemoryAppSettingsRepository(sharedPreferences: sharedPrefs);
      final progressRepo1 = InMemoryProgressRepository(sharedPreferences: sharedPrefs);
      final moodRepo1 = InMemoryMoodRepository(sharedPreferences: sharedPrefs);
      final reminderRepo1 = InMemoryReminderRepository(sharedPreferences: sharedPrefs);

      // Mood check-in
      await moodRepo1.recordMood(MoodType.stressed, note: 'Busy workday');

      // Complete session
      final record = SessionRecord(
        id: 'record_test_1',
        sessionId: 'session_1m_reset',
        sessionTitle: 'One Minute Reset',
        sessionType: SessionType.guidedMeditation,
        startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        completedAt: DateTime.now(),
        durationCompletedSeconds: 60,
        wasCompleted: true,
        moodBefore: MoodType.stressed,
        moodAfter: ReflectionMood.moreRelaxed,
      );
      await progressRepo1.recordSession(record);

      // Bookmark favorite
      await sessionRepo1.toggleFavorite('session_1m_reset');

      // Update preferences
      await userRepo1.setFirstName('Shahzad');
      await userRepo1.setGoals(['Feel calmer', 'Reduce everyday stress']);
      await userRepo1.setPreferredDuration(600);
      await userRepo1.setThemePreference(AppThemePreference.dark);
      await userRepo1.setReducedMotion(true);

      // Update app settings
      await settingsRepo1.setOfflineAudioCached(true);

      // Add custom reminder
      const newReminder = ReminderSchedule(
        id: 'reminder_custom_noon',
        slot: ReminderSlot.afternoon,
        hour: 12,
        minute: 15,
        daysOfWeek: [1, 2, 3, 4, 5],
        isEnabled: true,
      );
      await reminderRepo1.saveReminder(newReminder);

      // --- SESSION 2: App restarts (New repository instances reading same storage) ---
      final sessionRepo2 = InMemorySessionRepository(sharedPreferences: sharedPrefs);
      final userRepo2 = InMemoryUserPreferencesRepository(sharedPreferences: sharedPrefs);
      final settingsRepo2 = InMemoryAppSettingsRepository(sharedPreferences: sharedPrefs);
      final progressRepo2 = InMemoryProgressRepository(sharedPreferences: sharedPrefs);
      final moodRepo2 = InMemoryMoodRepository(sharedPreferences: sharedPrefs);
      final reminderRepo2 = InMemoryReminderRepository(sharedPreferences: sharedPrefs);

      // Verify mood restored
      final restoredMood = await moodRepo2.getLatestMood();
      expect(restoredMood?.mood, MoodType.stressed);
      expect(restoredMood?.note, 'Busy workday');

      // Verify history & stats restored
      final restoredHistory = await progressRepo2.getHistory();
      expect(restoredHistory.length, 1);
      expect(restoredHistory.first.sessionTitle, 'One Minute Reset');
      expect(restoredHistory.first.moodAfter, ReflectionMood.moreRelaxed);

      final stats = await progressRepo2.getStats();
      expect(stats.totalSessions, 1);
      expect(stats.totalMinutes, 1);

      // Verify favorite restored
      final isFav = await sessionRepo2.isFavorite('session_1m_reset');
      expect(isFav, true);

      // Verify preferences restored
      final restoredPrefs = await userRepo2.getPreferences();
      expect(restoredPrefs.firstName, 'Shahzad');
      expect(restoredPrefs.goals, contains('Feel calmer'));
      expect(restoredPrefs.preferredDurationSeconds, 600);
      expect(restoredPrefs.themeMode, AppThemePreference.dark);
      expect(restoredPrefs.reducedMotion, true);

      // Verify settings restored
      final restoredSettings = await settingsRepo2.getSettings();
      expect(restoredSettings.offlineAudioCached, true);

      // Verify reminders restored
      final restoredReminders = await reminderRepo2.getReminders();
      expect(restoredReminders.any((r) => r.id == 'reminder_custom_noon'), true);
    });

    test('Connectivity changes do not disrupt recommendation engine or practice session', () async {
      final connectivity = OfflineFirstConnectivityService(initialStatus: NetworkStatus.online);
      expect(connectivity.isOnline, true);
      expect(connectivity.isOffline, false);

      // Network drops to offline
      connectivity.setNetworkStatus(NetworkStatus.offline);
      expect(connectivity.isOffline, true);
      expect(connectivity.isOnline, false);

      // Recommendation engine executes normally offline
      const engine = RecommendationEngine();
      final recommendation = engine.recommend(
        allSessions: LocalContentSeed.sessions,
        preferences: const UserPreferences(preferredDurationSeconds: 300),
        history: [],
        currentMood: MoodType.calm,
        currentTime: DateTime(2026, 9, 26, 14, 0),
      );
      expect(recommendation.primarySession, isNotNull);
      expect(recommendation.quickResets.isNotEmpty, true);

      // Active session executes normally offline
      final audioService = InMemoryAudioService();
      final sessionEngine = SessionEngineNotifier(
        sessionRepository: InMemorySessionRepository(),
        progressRepository: InMemoryProgressRepository(),
        breathingPatternRepository: InMemoryBreathingPatternRepository(),
        calculator: const BreathingCalculator(),
        audioService: audioService,
      );

      await sessionEngine.initSession('session_1m_reset');
      sessionEngine.start();
      expect(sessionEngine.state.isPlaying, true);

      sessionEngine.pause();
      expect(sessionEngine.state.isPaused, true);

      sessionEngine.resume();
      expect(sessionEngine.state.isPlaying, true);

      await sessionEngine.finish(wasCompleted: true);
      expect(sessionEngine.state.isCompleted, true);

      // Network restored to online
      connectivity.setNetworkStatus(NetworkStatus.online);
      expect(connectivity.isOnline, true);

      sessionEngine.dispose();
      audioService.dispose();
      connectivity.dispose();
    });

    test('Graceful fault recovery: corrupt SharedPreferences data recovers to defaults without crashing', () async {
      // Simulate corrupt JSON string in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'melo_saved_user_preferences_json': 'NOT_VALID_JSON{{{',
        'melo_saved_app_settings_json': 'CORRUPT_SETTINGS',
        'melo_saved_session_records_json': 'INVALID_RECORDS',
        'melo_saved_mood_entries_json': 'INVALID_MOODS',
        'melo_saved_reminders_json': 'INVALID_REMINDERS',
      });

      final sharedPrefs = await SharedPreferences.getInstance();

      // Repositories should not throw when reading corrupt data
      final userRepo = InMemoryUserPreferencesRepository(sharedPreferences: sharedPrefs);
      final settingsRepo = InMemoryAppSettingsRepository(sharedPreferences: sharedPrefs);
      final progressRepo = InMemoryProgressRepository(sharedPreferences: sharedPrefs);
      final moodRepo = InMemoryMoodRepository(sharedPreferences: sharedPrefs);
      final reminderRepo = InMemoryReminderRepository(sharedPreferences: sharedPrefs);

      final prefs = await userRepo.getPreferences();
      expect(prefs.themeMode, AppThemePreference.system);

      final settings = await settingsRepo.getSettings();
      expect(settings.backgroundAudioEnabled, true);

      final history = await progressRepo.getHistory();
      expect(history, isEmpty);

      final mood = await moodRepo.getLatestMood();
      expect(mood, isNull);

      final reminders = await reminderRepo.getReminders();
      expect(reminders.isNotEmpty, true);
    });

    test('Graceful fallback: missing audio asset does not crash session engine', () async {
      final audioService = InMemoryAudioService(simulateMissingAsset: true);
      final sessionEngine = SessionEngineNotifier(
        sessionRepository: InMemorySessionRepository(),
        progressRepository: InMemoryProgressRepository(),
        breathingPatternRepository: InMemoryBreathingPatternRepository(),
        calculator: const BreathingCalculator(),
        audioService: audioService,
      );

      // Session with missing audio file
      await sessionEngine.initSession('session_1m_reset');

      // State is ready and has fallback mode active
      expect(sessionEngine.state.state, SessionState.idle);
      expect(sessionEngine.state.isFallbackMode, true);

      // Starts and runs smoothly in text-guided mode
      sessionEngine.start();
      expect(sessionEngine.state.isPlaying, true);
      expect(sessionEngine.state.currentInstruction, isNotEmpty);

      await sessionEngine.finish(wasCompleted: true);
      expect(sessionEngine.state.isCompleted, true);

      sessionEngine.dispose();
      audioService.dispose();
    });
  });
}
