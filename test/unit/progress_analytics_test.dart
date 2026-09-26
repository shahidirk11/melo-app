import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/features/progress/domain/progress_analytics.dart';

void main() {
  group('ProgressAnalytics Edge Case Calculations', () {
    SessionRecord makeRecord({
      required String id,
      required DateTime completedAt,
      int durationSeconds = 300,
      bool wasCompleted = true,
      String title = 'Calm Reset',
    }) {
      return SessionRecord(
        id: id,
        sessionId: 'session_$id',
        sessionTitle: title,
        sessionType: SessionType.guidedMeditation,
        startedAt: completedAt.subtract(Duration(seconds: durationSeconds)),
        completedAt: completedAt,
        durationCompletedSeconds: durationSeconds,
        wasCompleted: wasCompleted,
      );
    }

    test('1. No sessions: returns zero metrics and warm, non-stressful copy', () {
      final now = DateTime(2026, 4, 15, 14, 0);
      final summary = ProgressAnalytics.calculate([], referenceNow: now);

      expect(summary.totalSessions, 0);
      expect(summary.totalMinutes, 0);
      expect(summary.activeDays, 0);
      expect(summary.gentleStreakDays, 0);
      expect(summary.todaySessions, 0);
      expect(summary.todayMinutes, 0);
      expect(summary.weeklySessions, 0);
      expect(summary.weeklyMinutes, 0);
      expect(summary.monthlySessions, 0);
      expect(summary.monthlyMinutes, 0);
      expect(summary.monthlyActiveDays, 0);
      expect(summary.streakHeadline, 'Ready for today 🌱');
      expect(summary.last7Days.length, 7);
      expect(summary.weeklyCopy, contains('A gentle week so far'));
    });

    test('2. One session today: streak is 1, active days is 1, total minutes calculated', () {
      final now = DateTime(2026, 4, 15, 14, 0);
      final records = [
        makeRecord(
          id: '1',
          completedAt: DateTime(2026, 4, 15, 9, 30),
          durationSeconds: 180, // 3 min
        ),
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.totalSessions, 1);
      expect(summary.totalMinutes, 3);
      expect(summary.activeDays, 1);
      expect(summary.todaySessions, 1);
      expect(summary.todayMinutes, 3);
      expect(summary.gentleStreakDays, 1);
      expect(summary.streakHeadline, '1 day of showing up 🌱');
      expect(summary.weeklyCopy, 'You practiced 1 time this week. You spent 3 minutes creating quiet moments.');
    });

    test('3. One session yesterday (none today yet): gentle streak holds from yesterday', () {
      final now = DateTime(2026, 4, 15, 10, 0);
      final records = [
        makeRecord(
          id: '1',
          completedAt: DateTime(2026, 4, 14, 18, 0), // yesterday
          durationSeconds: 300,
        ),
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.totalSessions, 1);
      expect(summary.gentleStreakDays, 1);
      expect(summary.todaySessions, 0);
      expect(summary.todayMinutes, 0);
      expect(summary.streakHeadline, '1 day of showing up 🌱');
      expect(summary.streakSubtitle, contains('Ready for today'));
    });

    test('4. Multiple sessions on the same day: counts as 1 active day and 1 streak day', () {
      final now = DateTime(2026, 4, 15, 20, 0);
      final records = [
        makeRecord(
          id: '1',
          completedAt: DateTime(2026, 4, 15, 8, 0),
          durationSeconds: 60, // 1 min
        ),
        makeRecord(
          id: '2',
          completedAt: DateTime(2026, 4, 15, 13, 0),
          durationSeconds: 300, // 5 min
        ),
        makeRecord(
          id: '3',
          completedAt: DateTime(2026, 4, 15, 19, 0),
          durationSeconds: 600, // 10 min
        ),
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.totalSessions, 3);
      expect(summary.totalMinutes, 16); // 1 + 5 + 10
      expect(summary.activeDays, 1);
      expect(summary.todaySessions, 3);
      expect(summary.todayMinutes, 16);
      expect(summary.gentleStreakDays, 1);
    });

    test('5. Consecutive days: calculates accurate gentle streak across days', () {
      final now = DateTime(2026, 4, 15, 12, 0);
      final records = [
        makeRecord(id: '1', completedAt: DateTime(2026, 4, 15, 9, 0)), // Day 4 (Today)
        makeRecord(id: '2', completedAt: DateTime(2026, 4, 14, 9, 0)), // Day 3
        makeRecord(id: '3', completedAt: DateTime(2026, 4, 13, 9, 0)), // Day 2
        makeRecord(id: '4', completedAt: DateTime(2026, 4, 12, 9, 0)), // Day 1
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.gentleStreakDays, 4);
      expect(summary.activeDays, 4);
      expect(summary.streakHeadline, '4 days of showing up 🌱');
      expect(summary.streakSubtitle, 'Showing kindness to yourself each day.');
    });

    test('6. Missed day: streak gently resets to 0 when yesterday and today are missed', () {
      final now = DateTime(2026, 4, 15, 12, 0);
      // Last practice was on April 13 (missed April 14 and April 15)
      final records = [
        makeRecord(id: '1', completedAt: DateTime(2026, 4, 13, 9, 0)),
        makeRecord(id: '2', completedAt: DateTime(2026, 4, 12, 9, 0)),
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.gentleStreakDays, 0);
      expect(summary.activeDays, 2);
      expect(summary.totalSessions, 2);
      expect(summary.streakHeadline, 'Ready for today 🌱');
    });

    test('7. Month transition: maintains streak accurately across month boundaries', () {
      // April 2, 2026 at 10:00 AM
      final now = DateTime(2026, 4, 2, 10, 0);
      final records = [
        makeRecord(id: '1', completedAt: DateTime(2026, 4, 2, 8, 0)),  // April 2 (today)
        makeRecord(id: '2', completedAt: DateTime(2026, 4, 1, 8, 0)),  // April 1
        makeRecord(id: '3', completedAt: DateTime(2026, 3, 31, 8, 0)), // March 31
        makeRecord(id: '4', completedAt: DateTime(2026, 3, 30, 8, 0)), // March 30
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.gentleStreakDays, 4);
      expect(summary.activeDays, 4);
      expect(summary.streakHeadline, '4 days of showing up 🌱');

      // Check month boundary separation: April has 2 sessions, March has 2 sessions
      expect(summary.monthlySessions, 2);
      expect(summary.monthlyActiveDays, 2);
      expect(summary.monthlyMinutes, 10);
      expect(summary.monthlyCopy, 'You took 2 mindful resets across 2 days this month.');
    });

    test('8. Year transition: maintains streak across Dec 31 to Jan 1', () {
      final now = DateTime(2027, 1, 2, 10, 0);
      final records = [
        makeRecord(id: '1', completedAt: DateTime(2027, 1, 2, 8, 0)),
        makeRecord(id: '2', completedAt: DateTime(2027, 1, 1, 8, 0)),
        makeRecord(id: '3', completedAt: DateTime(2026, 12, 31, 8, 0)),
        makeRecord(id: '4', completedAt: DateTime(2026, 12, 30, 8, 0)),
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.gentleStreakDays, 4);
      expect(summary.activeDays, 4);
      expect(summary.monthlySessions, 2); // only Jan 2027
    });

    test('9. Timezone-sensitive boundaries: 23:59 vs 00:01 correctly separated', () {
      final now = DateTime(2026, 5, 2, 1, 0);
      final records = [
        makeRecord(id: '1', completedAt: DateTime(2026, 5, 1, 23, 59)), // May 1 night
        makeRecord(id: '2', completedAt: DateTime(2026, 5, 2, 0, 1)),   // May 2 morning
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.activeDays, 2);
      expect(summary.gentleStreakDays, 2);
      expect(summary.todaySessions, 1);
    });

    test('10. Abandoned sessions: never counted towards sessions, minutes, active days, or streaks', () {
      final now = DateTime(2026, 4, 15, 12, 0);
      final records = [
        makeRecord(
          id: 'abandoned_today',
          completedAt: DateTime(2026, 4, 15, 10, 0),
          durationSeconds: 45,
          wasCompleted: false, // User left early
        ),
        makeRecord(
          id: 'abandoned_yesterday',
          completedAt: DateTime(2026, 4, 14, 10, 0),
          durationSeconds: 120,
          wasCompleted: false, // User left early
        ),
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      expect(summary.totalSessions, 0);
      expect(summary.totalMinutes, 0);
      expect(summary.activeDays, 0);
      expect(summary.gentleStreakDays, 0);
      expect(summary.todaySessions, 0);
      expect(summary.todayMinutes, 0);
    });

    test('11. Weekly summary copy: non-clinical and avoids medical claims', () {
      final now = DateTime(2026, 4, 15, 12, 0);
      final records = [
        makeRecord(id: '1', completedAt: DateTime(2026, 4, 15, 8, 0), durationSeconds: 300),
        makeRecord(id: '2', completedAt: DateTime(2026, 4, 14, 8, 0), durationSeconds: 300),
        makeRecord(id: '3', completedAt: DateTime(2026, 4, 13, 8, 0), durationSeconds: 360),
        makeRecord(id: '4', completedAt: DateTime(2026, 4, 12, 8, 0), durationSeconds: 360),
      ];

      final summary = ProgressAnalytics.calculate(records, referenceNow: now);
      // 4 sessions, 22 minutes (5 + 5 + 6 + 6 = 22)
      expect(summary.weeklySessions, 4);
      expect(summary.weeklyMinutes, 22);
      expect(
        summary.weeklyCopy,
        'You practiced 4 times this week. You spent 22 minutes creating quiet moments.',
      );
      // Ensure zero unsupported medical claims
      expect(summary.weeklyCopy.contains('anxiety'), isFalse);
      expect(summary.weeklyCopy.contains('improved'), isFalse);
      expect(summary.weeklyCopy.contains('%'), isFalse);
    });
  });
}
