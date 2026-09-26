import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/data/models/breathing_pattern_model.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/reminder_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';

void main() {
  group('Models Unit Tests', () {
    test('UserPreferences default values and copyWith work as expected', () {
      const prefs = UserPreferences();
      expect(prefs.id, 'default_user');
      expect(prefs.preferredDurationSeconds, 300);
      expect(prefs.onboardingCompleted, false);

      final updated = prefs.copyWith(
        firstName: 'Shahzad',
        onboardingCompleted: true,
        themeMode: AppThemePreference.dark,
      );

      expect(updated.firstName, 'Shahzad');
      expect(updated.onboardingCompleted, true);
      expect(updated.themeMode, AppThemePreference.dark);
      expect(updated.preferredDurationSeconds, 300);
    });

    test('BreathingPattern cycle and total durations calculate accurately', () {
      const pattern = BreathingPattern.boxBreathing;
      expect(pattern.inhaleSeconds, 4);
      expect(pattern.holdAfterInhaleSeconds, 4);
      expect(pattern.exhaleSeconds, 4);
      expect(pattern.holdAfterExhaleSeconds, 4);
      expect(pattern.cycleDurationSeconds, 16);
      expect(pattern.totalCycles, 5);
      expect(pattern.totalDurationSeconds, 80);
    });

    test('ReminderSchedule time formatting handles AM and PM correctly', () {
      const morning = ReminderSchedule(
        id: 'rem_1',
        slot: ReminderSlot.morning,
        hour: 8,
        minute: 5,
        daysOfWeek: [1, 2, 3, 4, 5],
      );
      expect(morning.formattedTime, '8:05 AM');

      const evening = ReminderSchedule(
        id: 'rem_2',
        slot: ReminderSlot.evening,
        hour: 20,
        minute: 30,
        daysOfWeek: [1, 2, 3, 4, 5],
      );
      expect(evening.formattedTime, '8:30 PM');
    });

    test('Session duration minutes helper works as expected', () {
      const session = Session(
        id: 'test_session',
        title: 'Test Calm',
        description: 'Test description',
        category: SessionCategory.calm,
        type: SessionType.guidedMeditation,
        durationSeconds: 300,
        difficulty: SessionDifficulty.beginner,
      );
      expect(session.durationMinutes, 5);
    });

    test('SessionRecord duration minutes helper calculates accurately', () {
      final now = DateTime.now();
      final record = SessionRecord(
        id: 'rec_1',
        sessionId: 'test_session',
        sessionTitle: 'Test Calm',
        sessionType: SessionType.guidedMeditation,
        startedAt: now.subtract(const Duration(minutes: 5)),
        completedAt: now,
        durationCompletedSeconds: 300,
        wasCompleted: true,
      );
      expect(record.durationCompletedMinutes, 5);
      expect(record.wasCompleted, true);
    });
  });
}
