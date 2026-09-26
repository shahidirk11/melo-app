import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/data/datasources/local_content_seed.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/features/home/domain/recommendation_engine.dart';

void main() {
  group('Deterministic RecommendationEngine Tests', () {
    const engine = RecommendationEngine();
    final allSessions = LocalContentSeed.sessions;

    test('Stressed mood prioritizes Stress Reset, Calm, or Breathing', () {
      final result = engine.recommend(
        allSessions: allSessions,
        preferences: const UserPreferences(),
        history: [],
        currentMood: MoodType.stressed,
        currentTime: DateTime(2026, 9, 26, 14, 0), // 2:00 PM
      );

      expect(
        result.primarySession.category == SessionCategory.stressReset ||
            result.primarySession.category == SessionCategory.calm ||
            result.primarySession.category == SessionCategory.breathing,
        true,
        reason: 'Recommended category: ${result.primarySession.category.displayName}',
      );
      expect(result.recommendationReason, contains('tension'));
    });

    test('Tired mood prioritizes Sleep or Relaxation', () {
      final result = engine.recommend(
        allSessions: allSessions,
        preferences: const UserPreferences(),
        history: [],
        currentMood: MoodType.tired,
        currentTime: DateTime(2026, 9, 26, 16, 0), // 4:00 PM
      );

      expect(
        result.primarySession.category == SessionCategory.sleep ||
            result.primarySession.category == SessionCategory.relaxation,
        true,
        reason: 'Recommended category: ${result.primarySession.category.displayName}',
      );
      expect(result.recommendationReason, contains('restorative'));
    });

    test('Morning time bucket prioritizes Morning sessions when mood is neutral', () {
      final result = engine.recommend(
        allSessions: allSessions,
        preferences: const UserPreferences(goals: ['Build a mindfulness habit']),
        history: [],
        currentMood: null,
        currentTime: DateTime(2026, 9, 26, 8, 30), // 8:30 AM
      );

      expect(
        result.primarySession.category == SessionCategory.morning ||
            result.primarySession.category == SessionCategory.calm,
        true,
      );
      expect(result.recommendationReason, contains('morning'));
    });

    test('Night time bucket prioritizes Sleep sessions', () {
      final result = engine.recommend(
        allSessions: allSessions,
        preferences: const UserPreferences(),
        history: [],
        currentMood: null,
        currentTime: DateTime(2026, 9, 26, 22, 30), // 10:30 PM
      );

      expect(result.primarySession.category, SessionCategory.sleep);
      expect(result.recommendationReason, contains('rest'));
    });

    test('Avoids recommending recently completed sessions (Recency Penalty)', () {
      final now = DateTime(2026, 9, 26, 14, 0);

      // Suppose user is stressed. Normally 'session_3m_stress_release' would win.
      // But user completed it 30 minutes ago.
      final history = [
        SessionRecord(
          id: 'rec_recent',
          sessionId: 'session_3m_stress_release',
          sessionTitle: 'Stress Release',
          sessionType: SessionType.guidedMeditation,
          startedAt: now.subtract(const Duration(minutes: 33)),
          completedAt: now.subtract(const Duration(minutes: 30)),
          durationCompletedSeconds: 180,
          wasCompleted: true,
        ),
      ];

      final result = engine.recommend(
        allSessions: allSessions,
        preferences: const UserPreferences(preferredDurationSeconds: 180),
        history: history,
        currentMood: MoodType.stressed,
        currentTime: now,
      );

      // Verify the recently completed session was penalized and NOT recommended
      expect(result.primarySession.id, isNot('session_3m_stress_release'));
    });

    test('New user with zero history receives sensible beginner recommendation', () {
      final result = engine.recommend(
        allSessions: allSessions,
        preferences: const UserPreferences(
          preferredDurationSeconds: 300,
          goals: ['Feel calmer'],
        ),
        history: [],
        currentMood: null,
        currentTime: DateTime(2026, 9, 26, 10, 0), // 10:00 AM
      );

      expect(result.primarySession, isNotNull);
      expect(result.quickResets.isNotEmpty, true);
      expect(result.quickResets.length, lessThanOrEqualTo(3));
      expect(result.quickResets.every((s) => s.durationSeconds <= 180), true);
    });

    test('User with extensive history receives fresh recommendation without crashes', () {
      final now = DateTime(2026, 9, 26, 18, 0);

      // Simulate 20 past sessions
      final history = List.generate(20, (i) {
        return SessionRecord(
          id: 'rec_$i',
          sessionId: allSessions[i % allSessions.length].id,
          sessionTitle: allSessions[i % allSessions.length].title,
          sessionType: allSessions[i % allSessions.length].type,
          startedAt: now.subtract(Duration(days: i + 1)),
          completedAt: now.subtract(Duration(days: i + 1, minutes: -5)),
          durationCompletedSeconds: 300,
          wasCompleted: true,
        );
      });

      final result = engine.recommend(
        allSessions: allSessions,
        preferences: const UserPreferences(
          preferredDurationSeconds: 600,
          goals: ['Improve focus', 'Sleep better'],
        ),
        history: history,
        currentMood: MoodType.good,
        currentTime: now,
      );

      expect(result.primarySession, isNotNull);
      expect(result.recommendationReason.isNotEmpty, true);
    });
  });
}
