import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';

void main() {
  group('ProgressRepository and Gentle Streak Tests', () {
    test('Calculates total minutes and sessions accurately', () async {
      final repo = InMemoryProgressRepository();
      final now = DateTime.now();

      await repo.recordSession(SessionRecord(
        id: '1',
        sessionId: 'session_1m_reset',
        sessionTitle: 'One Minute Reset',
        sessionType: SessionType.guidedMeditation,
        startedAt: now.subtract(const Duration(minutes: 1)),
        completedAt: now,
        durationCompletedSeconds: 60,
        wasCompleted: true,
      ));

      await repo.recordSession(SessionRecord(
        id: '2',
        sessionId: 'session_5m_calm_mind',
        sessionTitle: 'Calm Your Mind',
        sessionType: SessionType.guidedMeditation,
        startedAt: now.subtract(const Duration(minutes: 6)),
        completedAt: now.subtract(const Duration(minutes: 1)),
        durationCompletedSeconds: 300,
        wasCompleted: true,
      ));

      final stats = await repo.getStats();
      expect(stats.totalSessions, 2);
      expect(stats.totalMinutes, 6);
      expect(stats.activeDays, 1);
      expect(stats.currentGentleStreakDays, 1);
    });

    test('Abandoned sessions do not count towards completed minutes', () async {
      final repo = InMemoryProgressRepository();
      final now = DateTime.now();

      await repo.recordSession(SessionRecord(
        id: 'abandoned',
        sessionId: 'session_5m_calm_mind',
        sessionTitle: 'Calm Your Mind',
        sessionType: SessionType.guidedMeditation,
        startedAt: now.subtract(const Duration(minutes: 2)),
        completedAt: now,
        durationCompletedSeconds: 45,
        wasCompleted: false, // Abandoned
      ));

      final stats = await repo.getStats();
      expect(stats.totalSessions, 0);
      expect(stats.totalMinutes, 0);
    });
  });
}
