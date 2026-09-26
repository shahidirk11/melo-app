import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/core/services/notification_service.dart';
import 'package:melo_app/data/models/reminder_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/data/repositories/reminder_repository.dart';
import 'package:melo_app/features/reminders/domain/schedule_suggestion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNotificationService implements NotificationService {
  bool permissionToReturn = true;
  final List<ScheduledNotificationInfo> _scheduled = [];
  void Function(String? payload)? tappedCallback;

  @override
  List<ScheduledNotificationInfo> get activeScheduledNotifications =>
      List.unmodifiable(_scheduled);

  @override
  Future<void> initialize({void Function(String? payload)? onNotificationTapped}) async {
    tappedCallback = onNotificationTapped;
  }

  @override
  Future<bool> requestPermission() async {
    return permissionToReturn;
  }

  @override
  Future<bool> isPermissionGranted() async {
    return permissionToReturn;
  }

  @override
  Future<void> scheduleReminder(ReminderSchedule reminder) async {
    await cancelReminder(reminder.id);
    if (!reminder.isEnabled) return;

    for (final day in reminder.daysOfWeek) {
      _scheduled.add(ScheduledNotificationInfo(
        id: (reminder.id.hashCode ^ day).abs() % 1000000,
        reminderId: reminder.id,
        title: reminder.notificationTitle,
        body: reminder.notificationBody,
        hour: reminder.hour,
        minute: reminder.minute,
        dayOfWeek: day,
        payload: reminder.deepLinkPayload ?? '/home',
      ));
    }
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    _scheduled.removeWhere((s) => s.reminderId == reminderId);
  }

  @override
  Future<void> cancelAll() async {
    _scheduled.clear();
  }

  @override
  Future<void> snoozeReminder({required ReminderSchedule reminder, int minutes = 15}) async {
    _scheduled.add(ScheduledNotificationInfo(
      id: 9999,
      reminderId: 'snooze_${reminder.id}',
      title: 'Mindful pause · Snoozed 🌿',
      body: 'Your $minutes-minute gentle pause is ready.',
      hour: 12,
      minute: 15,
      dayOfWeek: 1,
      payload: reminder.deepLinkPayload ?? '/home',
    ));
  }

  @override
  Future<void> showInstantTestNotification({
    required String title,
    required String body,
    String? payload,
  }) async {}
}

void main() {
  group('Reminder Model & Supportive Notification Copy', () {
    test('Generates kind, supportive copy without guilt or streaks', () {
      const morning = ReminderSchedule(
        id: 'm1',
        slot: ReminderSlot.morning,
        hour: 8,
        minute: 0,
        daysOfWeek: [1, 2, 3, 4, 5],
      );

      expect(morning.notificationTitle, contains('Good morning'));
      expect(morning.notificationBody, 'A small reset might feel good right now.');
      expect(morning.notificationBody.contains('streak'), isFalse);
      expect(morning.notificationBody.contains('haven\'t meditated'), isFalse);

      const evening = ReminderSchedule(
        id: 'e1',
        slot: ReminderSlot.evening,
        hour: 20,
        minute: 30,
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      );

      expect(evening.notificationTitle, contains('Evening wind-down'));
      expect(evening.notificationBody, 'Ready for your evening wind-down?');
      expect(evening.isEveryday, isTrue);
      expect(evening.daysDescription, 'Every day');
    });

    test('Formatted time and custom days description', () {
      const schedule = ReminderSchedule(
        id: 'c1',
        slot: ReminderSlot.custom,
        hour: 14,
        minute: 5,
        daysOfWeek: [1, 3, 5],
      );

      expect(schedule.formattedTime, '2:05 PM');
      expect(schedule.daysDescription, 'Mon, Wed, Fri');
      expect(schedule.isWeekdaysOnly, isFalse);
    });
  });

  group('NotificationService: Scheduling, Cancellation, Rescheduling, Snooze, Deep Links', () {
    late MockNotificationService service;

    setUp(() {
      service = MockNotificationService();
    });

    test('1. Permission granted vs denied', () async {
      service.permissionToReturn = true;
      expect(await service.requestPermission(), isTrue);
      expect(await service.isPermissionGranted(), isTrue);

      service.permissionToReturn = false;
      expect(await service.requestPermission(), isFalse);
      expect(await service.isPermissionGranted(), isFalse);
    });

    test('2. Scheduling multiple days creates scheduled alarms with deep links', () async {
      const reminder = ReminderSchedule(
        id: 'rem_weekday',
        slot: ReminderSlot.morning,
        hour: 8,
        minute: 30,
        daysOfWeek: [1, 2, 3, 4, 5], // 5 weekdays
        deepLinkPayload: '/session/session_1m_reset',
      );

      await service.scheduleReminder(reminder);
      expect(service.activeScheduledNotifications.length, 5);

      for (final alarm in service.activeScheduledNotifications) {
        expect(alarm.reminderId, 'rem_weekday');
        expect(alarm.hour, 8);
        expect(alarm.minute, 30);
        expect(alarm.payload, '/session/session_1m_reset');
        expect(alarm.title, contains('Good morning'));
      }
    });

    test('3. Cancellation removes all alarms for that reminder', () async {
      const r1 = ReminderSchedule(
        id: 'r1',
        slot: ReminderSlot.morning,
        hour: 8,
        minute: 0,
        daysOfWeek: [1, 2, 3],
      );
      const r2 = ReminderSchedule(
        id: 'r2',
        slot: ReminderSlot.evening,
        hour: 20,
        minute: 0,
        daysOfWeek: [6, 7],
      );

      await service.scheduleReminder(r1);
      await service.scheduleReminder(r2);
      expect(service.activeScheduledNotifications.length, 5);

      await service.cancelReminder('r1');
      expect(service.activeScheduledNotifications.length, 2);
      expect(service.activeScheduledNotifications.every((a) => a.reminderId == 'r2'), isTrue);
    });

    test('4. Rescheduling replaces old alarms cleanly without duplicates', () async {
      const initial = ReminderSchedule(
        id: 'r1',
        slot: ReminderSlot.morning,
        hour: 8,
        minute: 0,
        daysOfWeek: [1, 2, 3],
      );

      await service.scheduleReminder(initial);
      expect(service.activeScheduledNotifications.length, 3);

      final updated = initial.copyWith(hour: 9, minute: 15, daysOfWeek: [1, 2, 3, 4, 5]);
      await service.scheduleReminder(updated);

      expect(service.activeScheduledNotifications.length, 5);
      for (final a in service.activeScheduledNotifications) {
        expect(a.hour, 9);
        expect(a.minute, 15);
      }
    });

    test('5. Snooze schedules a one-time quiet pause reminder', () async {
      const r1 = ReminderSchedule(
        id: 'r1',
        slot: ReminderSlot.afternoon,
        hour: 14,
        minute: 0,
        daysOfWeek: [1],
        deepLinkPayload: '/home',
      );

      await service.snoozeReminder(reminder: r1, minutes: 15);
      final snoozeAlarm = service.activeScheduledNotifications.firstWhere((a) => a.reminderId == 'snooze_r1');
      expect(snoozeAlarm.title, contains('Snoozed 🌿'));
      expect(snoozeAlarm.body, contains('15-minute gentle pause'));
      expect(snoozeAlarm.payload, '/home');
    });

    test('6. Notification deep link callback fires on tap', () async {
      String? tappedPayload;
      await service.initialize(onNotificationTapped: (payload) {
        tappedPayload = payload;
      });

      // Simulate notification tap
      service.tappedCallback?.call('/session/session_5m_calm_mind');
      expect(tappedPayload, '/session/session_5m_calm_mind');
    });
  });

  group('ScheduleSuggestionService: Habit Analysis & Respectful Suggestions', () {
    SessionRecord makeRecord(int hour) {
      final dt = DateTime(2026, 4, 10, hour, 5);
      return SessionRecord(
        id: 'rec_$hour',
        sessionId: 'session_1m_reset',
        sessionTitle: 'Reset',
        sessionType: SessionType.guidedMeditation,
        startedAt: dt.subtract(const Duration(minutes: 1)),
        completedAt: dt,
        durationCompletedSeconds: 60,
        wasCompleted: true,
      );
    }

    test('Suggests schedule adjustment when user repeatedly practices at a different time', () {
      final reminders = [
        const ReminderSchedule(
          id: 'rem_evening',
          slot: ReminderSlot.evening,
          hour: 20, // 8:00 PM
          minute: 0,
          daysOfWeek: [1, 2, 3, 4, 5],
          isEnabled: true,
        ),
      ];

      // User consistently practices at 22:00 (10:00 PM) 3 times
      final history = [
        makeRecord(22),
        makeRecord(22),
        makeRecord(22),
      ];

      final suggestion = ScheduleSuggestionService.analyzePracticeHabits(
        reminders: reminders,
        history: history,
      );

      expect(suggestion, isNotNull);
      expect(suggestion!.reminderId, 'rem_evening');
      expect(suggestion.suggestedHour, 22);
      expect(suggestion.suggestedFormattedTime, '10:00 PM');
      expect(suggestion.promptQuestion, contains('adjust your Evening Wind-Down from 8:00 PM to 10:00 PM'));
    });

    test('Does not suggest adjustment if user practice times already align with reminder', () {
      final reminders = [
        const ReminderSchedule(
          id: 'rem_morning',
          slot: ReminderSlot.morning,
          hour: 8,
          minute: 30,
          daysOfWeek: [1, 2, 3, 4, 5],
          isEnabled: true,
        ),
      ];

      // User practices at 8:00 AM (within 1 hour)
      final history = [
        makeRecord(8),
        makeRecord(8),
        makeRecord(8),
      ];

      final suggestion = ScheduleSuggestionService.analyzePracticeHabits(
        reminders: reminders,
        history: history,
      );

      expect(suggestion, isNull);
    });
  });

  group('ReminderRepository Persistence & App Restart Simulation', () {
    test('Persists reminders and allPaused across app restarts using SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // 1. Initial app run
      final repo1 = InMemoryReminderRepository(sharedPreferences: prefs);
      final initialReminders = await repo1.getReminders();
      expect(initialReminders.length, 2);

      // Modify time and add a custom reminder
      final morning = initialReminders.first;
      await repo1.saveReminder(morning.copyWith(hour: 7, minute: 45));
      await repo1.saveReminder(const ReminderSchedule(
        id: 'rem_midday',
        slot: ReminderSlot.custom,
        hour: 13,
        minute: 15,
        daysOfWeek: [1, 3, 5],
      ));
      await repo1.setAllPaused(true);

      // 2. Simulate App Restart (new repository instance reading the same SharedPreferences)
      final repo2 = InMemoryReminderRepository(sharedPreferences: prefs);
      // Wait for async init persistence
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final restoredReminders = await repo2.getReminders();
      final restoredAllPaused = await repo2.areAllPaused();

      expect(restoredAllPaused, isTrue);
      expect(restoredReminders.length, 3);

      final restoredMorning = restoredReminders.firstWhere((r) => r.id == morning.id);
      expect(restoredMorning.hour, 7);
      expect(restoredMorning.minute, 45);

      final restoredMidday = restoredReminders.firstWhere((r) => r.id == 'rem_midday');
      expect(restoredMidday.hour, 13);
      expect(restoredMidday.minute, 15);
      expect(restoredMidday.daysOfWeek, [1, 3, 5]);
    });
  });
}
