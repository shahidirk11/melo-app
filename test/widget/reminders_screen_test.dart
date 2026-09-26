import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/app/theme/app_theme.dart';
import 'package:melo_app/core/services/notification_service.dart';
import 'package:melo_app/data/models/reminder_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/reminder_repository.dart';
import 'package:melo_app/features/reminders/presentation/reminders_screen.dart';
import 'package:melo_app/features/reminders/presentation/widgets/edit_reminder_modal.dart';
import 'package:melo_app/features/reminders/presentation/widgets/notification_permission_dialog.dart';
import 'package:melo_app/features/reminders/presentation/widgets/reminder_card.dart';
import 'package:melo_app/features/reminders/presentation/widgets/schedule_suggestion_card.dart';

class FakeNotificationService implements NotificationService {
  bool permission = false;
  final List<ScheduledNotificationInfo> alarms = [];

  @override
  List<ScheduledNotificationInfo> get activeScheduledNotifications => alarms;

  @override
  Future<void> initialize({void Function(String? payload)? onNotificationTapped}) async {}

  @override
  Future<bool> requestPermission() async {
    permission = true;
    return true;
  }

  @override
  Future<bool> isPermissionGranted() async => permission;

  @override
  Future<void> scheduleReminder(ReminderSchedule reminder) async {
    await cancelReminder(reminder.id);
    if (!reminder.isEnabled) return;
    for (final day in reminder.daysOfWeek) {
      alarms.add(ScheduledNotificationInfo(
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
    alarms.removeWhere((a) => a.reminderId == reminderId);
  }

  @override
  Future<void> cancelAll() async {
    alarms.clear();
  }

  @override
  Future<void> snoozeReminder({required ReminderSchedule reminder, int minutes = 15}) async {
    alarms.add(ScheduledNotificationInfo(
      id: 8888,
      reminderId: 'snooze_${reminder.id}',
      title: 'Mindful pause · Snoozed 🌿',
      body: 'Your $minutes-minute gentle pause is ready.',
      hour: 12,
      minute: 15,
      dayOfWeek: 1,
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
  group('RemindersScreen Widget Tests', () {
    late InMemoryReminderRepository reminderRepo;
    late FakeNotificationService notificationService;
    late InMemoryProgressRepository progressRepo;

    setUp(() {
      reminderRepo = InMemoryReminderRepository();
      notificationService = FakeNotificationService();
      progressRepo = InMemoryProgressRepository();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          reminderRepositoryProvider.overrideWithValue(reminderRepo),
          notificationServiceProvider.overrideWithValue(notificationService),
          progressRepositoryProvider.overrideWithValue(progressRepo),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const RemindersScreen(),
        ),
      );
    }

    testWidgets('1. Renders screen, reminder cards, and pause-all toggle', (tester) async {
      notificationService.permission = true; // granted
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Mindful Reminders'), findsOneWidget);
      expect(find.text('Pause all reminders'), findsOneWidget);
      expect(find.text('Daily & Weekly Resets'), findsOneWidget);
      expect(find.byType(ReminderCard), findsWidgets);
      expect(find.text('Morning Reset'), findsOneWidget);
      expect(find.text('Evening Wind-Down'), findsOneWidget);
      expect(find.text('Add Custom Reminder'), findsOneWidget);
      expect(find.textContaining('will never guilt-trip you'), findsOneWidget);
    });

    testWidgets('2. Permission flow: explains benefits before requesting permission', (tester) async {
      notificationService.permission = false; // not granted
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Banner shows reminders are off
      expect(find.text('Reminders are currently off'), findsOneWidget);
      expect(find.text('Enable notifications'), findsOneWidget);

      // Tap enable notifications
      await tester.tap(find.text('Enable notifications'));
      await tester.pumpAndSettle();

      // Explanation dialog opens
      expect(find.byType(NotificationPermissionDialog), findsOneWidget);
      expect(find.text('Gentle reminders on your terms'), findsOneWidget);
      expect(find.text('Zero guilt streaks or competitive pressure.'), findsOneWidget);

      // Tap Enable Reminders
      await tester.tap(find.text('Enable Reminders'));
      await tester.pumpAndSettle();

      expect(notificationService.permission, isTrue);
      expect(find.text('Reminders enabled. We will keep them gentle.'), findsOneWidget);
    });

    testWidgets('3. Edit reminder: opens modal, changes days to Every day, and saves', (tester) async {
      notificationService.permission = true;
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Morning Reset card
      await tester.tap(find.text('Morning Reset'));
      await tester.pumpAndSettle();

      // Verify modal is open
      expect(find.byType(EditReminderModal), findsOneWidget);
      expect(find.text('Every day'), findsOneWidget);
      expect(find.text('Weekdays'), findsOneWidget);

      // Select 'Every day'
      await tester.tap(find.text('Every day'));
      await tester.pumpAndSettle();

      // Tap Save Changes
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      // Modal closed and days updated
      expect(find.byType(EditReminderModal), findsNothing);
      expect(find.text('Reminder time updated.'), findsOneWidget);
      expect(find.text('· Every day'), findsWidgets);
    });

    testWidgets('4. Schedule suggestion: prompts habit-based adjustment and updates reminder', (tester) async {
      notificationService.permission = true;

      // Seed 3 practice records at 22:00 (10:00 PM) to trigger habit suggestion
      final now = DateTime.now();
      for (int i = 1; i <= 3; i++) {
        final dt = DateTime(now.year, now.month, now.day - i, 22, 10);
        await progressRepo.recordSession(SessionRecord(
          id: 'seed_$i',
          sessionId: 'session_10m_sleep',
          sessionTitle: 'Sleep Reset',
          sessionType: SessionType.sleep,
          startedAt: dt.subtract(const Duration(minutes: 10)),
          completedAt: dt,
          durationCompletedSeconds: 600,
          wasCompleted: true,
        ));
      }

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify ScheduleSuggestionCard appears
      expect(find.byType(ScheduleSuggestionCard), findsOneWidget);
      expect(find.text('Natural rhythm detected'), findsOneWidget);
      expect(find.text('Update to 10:00 PM'), findsOneWidget);

      // Tap update to 10:00 PM
      await tester.tap(find.text('Update to 10:00 PM'));
      await tester.pumpAndSettle();

      // Card dismissed and time updated
      expect(find.byType(ScheduleSuggestionCard), findsNothing);
      expect(find.text('10:00 PM'), findsOneWidget);
      expect(find.text('Schedule adjusted to your practice rhythm.'), findsOneWidget);
    });

    testWidgets('5. Pause all: toggling pause-all silences all notifications', (tester) async {
      notificationService.permission = true;
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Toggle Pause all
      final pauseSwitch = find.byType(Switch).first;
      await tester.tap(pauseSwitch);
      await tester.pumpAndSettle();

      expect(find.text('All reminders are temporarily silenced.'), findsOneWidget);
      expect(notificationService.alarms.isEmpty, isTrue);

      // Toggle Unpause
      await tester.tap(pauseSwitch);
      await tester.pumpAndSettle();

      expect(find.text('Silence reminders whenever you need quiet space.'), findsOneWidget);
      expect(notificationService.alarms.isNotEmpty, isTrue);
    });

    testWidgets('6. Snooze: tapping snooze schedules 15m delay', (tester) async {
      notificationService.permission = true;
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Snooze 15m
      final snoozeBtn = find.text('Snooze 15m').first;
      await tester.tap(snoozeBtn);
      await tester.pumpAndSettle();

      expect(find.text('Reminder snoozed for 15 minutes 🌿'), findsOneWidget);
      expect(notificationService.alarms.any((a) => a.reminderId.contains('snooze')), isTrue);
    });
  });
}
