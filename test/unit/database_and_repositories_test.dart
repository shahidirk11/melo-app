import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/data/database/database.dart';
import 'package:melo_app/data/datasources/local_content_seed.dart';
import 'package:melo_app/data/models/app_settings_model.dart';
import 'package:melo_app/data/models/breathing_pattern_model.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/reminder_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/app_settings_repository.dart';
import 'package:melo_app/data/repositories/breathing_pattern_repository.dart';
import 'package:melo_app/data/repositories/mood_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/reminder_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';

void main() {
  group('Phase 4: Database Schema, Migrations, and Repositories Tests', () {
    test('Database schema defines all 8 required tables and migration strategy', () {
      // Create a mock or in-memory Drift schema inspection
      final db = AppDatabase(DatabaseConnection.fromExecutor(
        // Verify schemaVersion matches 1
        const QueryExecutorUserPreferencesMock(),
      ));

      expect(db.schemaVersion, 1);
      expect(db.allTables.length, 8);
      expect(db.allSchemaEntities.map((e) => e.entityName), containsAll([
        'user_preferences_table',
        'mood_entries_table',
        'sessions_table',
        'session_records_table',
        'reminders_table',
        'favorites_table',
        'breathing_patterns_table',
        'app_settings_table',
      ]));

      // Verify migration strategy is configured
      expect(db.migration, isNotNull);
    });

    test('Seed content satisfies all required categories, durations, and metadata', () {
      final sessions = LocalContentSeed.sessions;
      expect(sessions.length, greaterThanOrEqualTo(16));

      // 1. Verify all 8 categories exist
      for (final cat in SessionCategory.values) {
        final matches = sessions.where((s) => s.category == cat);
        expect(matches.isNotEmpty, true, reason: 'Missing category: ${cat.displayName}');
      }

      // 2. Verify all required duration tiers exist
      expect(sessions.any((s) => s.durationSeconds == 60), true, reason: '1-minute session missing');
      expect(sessions.any((s) => s.durationSeconds == 180), true, reason: '3-minute session missing');
      expect(sessions.any((s) => s.durationSeconds == 300), true, reason: '5-minute session missing');
      expect(sessions.any((s) => s.durationSeconds == 600), true, reason: '10-minute session missing');
      expect(sessions.any((s) => s.category == SessionCategory.sleep), true, reason: 'Sleep session missing');

      // 3. Verify metadata completeness on every session
      for (final s in sessions) {
        expect(s.id.isNotEmpty, true);
        expect(s.title.isNotEmpty, true);
        expect(s.description.isNotEmpty, true);
        expect(s.tags.isNotEmpty, true);
        expect(s.guidanceSteps.isNotEmpty, true, reason: 'Guidance steps missing in ${s.id}');
        expect(s.isPremium, false); // Free starter pack
      }
    });

    test('SessionRepository: CRUD, search, categories, and favorites persistence', () async {
      final repo = InMemorySessionRepository();

      // Get all
      final all = await repo.getAllSessions();
      expect(all.length, LocalContentSeed.sessions.length);

      // Search
      final calmSearch = await repo.searchSessions('calm');
      expect(calmSearch.isNotEmpty, true);

      // Category query
      final sleepSessions = await repo.getSessionsByCategory(SessionCategory.sleep);
      expect(sleepSessions.length, greaterThanOrEqualTo(3));

      // Favorites
      const testId = 'session_5m_calm_mind';
      expect(await repo.isFavorite(testId), false);
      await repo.toggleFavorite(testId);
      expect(await repo.isFavorite(testId), true);
      final favs = await repo.getFavoriteSessions();
      expect(favs.any((s) => s.id == testId), true);

      // Add custom session (Create)
      const custom = Session(
        id: 'session_custom_reset',
        title: 'Custom Reset',
        description: 'A custom session for testing',
        category: SessionCategory.focus,
        type: SessionType.focus,
        durationSeconds: 240,
        difficulty: SessionDifficulty.beginner,
      );
      await repo.addSession(custom);
      expect((await repo.getSessionById('session_custom_reset'))?.title, 'Custom Reset');

      // Update
      final updated = custom.copyWith(title: 'Updated Reset');
      await repo.updateSession(updated);
      expect((await repo.getSessionById('session_custom_reset'))?.title, 'Updated Reset');

      // Delete
      await repo.deleteSession('session_custom_reset');
      expect(await repo.getSessionById('session_custom_reset'), isNull);
    });

    test('MoodRepository: CRUD, recent query, date filter, and clear', () async {
      final repo = InMemoryMoodRepository();
      expect(await repo.getLatestMood(), isNull);

      // Record moods
      await repo.recordMood(MoodType.calm, note: 'Feeling centered');
      await repo.recordMood(MoodType.good);

      final latest = await repo.getLatestMood();
      expect(latest?.mood, MoodType.good);

      final recent = await repo.getRecentMoods();
      expect(recent.length, 2);

      // Query by day
      final todayMoods = await repo.getMoodsForDay(DateTime.now());
      expect(todayMoods.length, 2);

      // Delete
      final firstId = recent.first.id;
      await repo.deleteMood(firstId);
      expect(await repo.getMoodById(firstId), isNull);

      // Clear all
      await repo.clearAllMoods();
      expect(await repo.getRecentMoods(), isEmpty);
    });

    test('UserPreferencesRepository: Get, update, and reset defaults', () async {
      final repo = InMemoryUserPreferencesRepository();
      final initial = await repo.getPreferences();
      expect(initial.onboardingCompleted, false);

      await repo.updatePreferences(initial.copyWith(
        firstName: 'Shahzad',
        onboardingCompleted: true,
      ));
      final updated = await repo.getPreferences();
      expect(updated.firstName, 'Shahzad');
      expect(updated.onboardingCompleted, true);

      await repo.resetToDefaults();
      final reset = await repo.getPreferences();
      expect(reset.firstName, '');
      expect(reset.onboardingCompleted, false);
    });

    test('ReminderRepository: CRUD, toggle, and schedules query', () async {
      final repo = InMemoryReminderRepository();
      final reminders = await repo.getReminders();
      expect(reminders.isNotEmpty, true);

      // Toggle
      final morning = reminders.first;
      await repo.toggleReminder(morning.id, false);
      final toggled = await repo.getReminderById(morning.id);
      expect(toggled?.isEnabled, false);

      // Save custom reminder
      const newRem = ReminderSchedule(
        id: 'rem_afternoon_pause',
        slot: ReminderSlot.afternoon,
        hour: 14,
        minute: 15,
        daysOfWeek: [1, 2, 3, 4, 5],
      );
      await repo.saveReminder(newRem);
      expect((await repo.getReminderById('rem_afternoon_pause'))?.minute, 15);

      // Delete
      await repo.deleteReminder('rem_afternoon_pause');
      expect(await repo.getReminderById('rem_afternoon_pause'), isNull);
    });

    test('BreathingPatternRepository: Default patterns and custom pattern addition', () async {
      final repo = InMemoryBreathingPatternRepository();
      final patterns = await repo.getPatterns();
      expect(patterns.length, 3); // Box, Relaxing 4-7-8, Simple

      const customPattern = BreathingPattern(
        id: 'deep_belly',
        name: 'Deep Belly Breath',
        description: 'Diaphragmatic breathing to activate parasympathetic system',
        inhaleSeconds: 4,
        holdAfterInhaleSeconds: 2,
        exhaleSeconds: 6,
        holdAfterExhaleSeconds: 1,
      );
      await repo.savePattern(customPattern);
      expect((await repo.getPatternById('deep_belly'))?.exhaleSeconds, 6);
    });

    test('AppSettingsRepository: Get settings and flag toggles', () async {
      final repo = InMemoryAppSettingsRepository();
      final settings = await repo.getSettings();
      expect(settings.offlineAudioCached, false);
      expect(settings.backgroundAudioEnabled, true);

      await repo.setOfflineAudioCached(true);
      expect((await repo.getSettings()).offlineAudioCached, true);
    });
  });
}

// Mock QueryExecutor to instantiate AppDatabase in unit tests without native SQLite bindings
class QueryExecutorUserPreferencesMock extends QueryExecutor {
  const QueryExecutorUserPreferencesMock();

  @override
  SqlDialect get dialect => SqlDialect.sqlite;

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async => true;

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {}

  @override
  Future<int> runDelete(String statement, List<Object?> args) async => 0;

  @override
  Future<int> runInsert(String statement, List<Object?> args) async => 0;

  @override
  Future<List<Map<String, Object?>>> runSelect(String statement, List<Object?> args) async => [];

  @override
  Future<int> runUpdate(String statement, List<Object?> args) async => 0;

  @override
  Future<void> runBatched(BatchedStatements statements) async {}

  @override
  TransactionExecutor beginTransaction() => throw UnimplementedError();
}
