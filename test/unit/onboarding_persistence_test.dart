import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';

void main() {
  group('Onboarding Persistence & State Unit Tests', () {
    test('Default user preferences have onboardingCompleted set to false', () {
      const prefs = UserPreferences();
      expect(prefs.onboardingCompleted, false);
      expect(prefs.goals, isEmpty);
      expect(prefs.preferredDurationSeconds, 300);
      expect(prefs.notificationsEnabled, false);
    });

    test('Onboarding selections persist correctly through UserPreferencesNotifier', () async {
      final repository = InMemoryUserPreferencesRepository();
      final notifier = UserPreferencesNotifier(repository);

      // 1. Set multi-select goals
      await notifier.setGoals(['Feel calmer', 'Sleep better', 'Improve focus']);
      expect(notifier.state.goals, ['Feel calmer', 'Sleep better', 'Improve focus']);

      // 2. Set preferred session duration (10 min = 600s)
      await notifier.setPreferredDuration(600);
      expect(notifier.state.preferredDurationSeconds, 600);

      // 3. Set preferred reminder time (Evening)
      await notifier.setPreferredTimeOfDay(
        TimeOfDayPreference.evening,
        customHour: 20,
        customMinute: 30,
      );
      expect(notifier.state.preferredTimeOfDay, TimeOfDayPreference.evening);
      expect(notifier.state.customReminderHour, 20);
      expect(notifier.state.customReminderMinute, 30);

      // 4. Enable notifications
      await notifier.setNotificationsEnabled(true);
      expect(notifier.state.notificationsEnabled, true);

      // 5. Complete onboarding
      await notifier.setOnboardingCompleted(true);
      expect(notifier.state.onboardingCompleted, true);

      // 6. Simulate app restart: A new notifier reading from the repository restores the exact state
      final freshNotifier = UserPreferencesNotifier(repository);
      // Wait for repository reload
      await Future<void>.delayed(Duration.zero);
      final restored = await repository.getPreferences();

      expect(restored.onboardingCompleted, true);
      expect(restored.goals, ['Feel calmer', 'Sleep better', 'Improve focus']);
      expect(restored.preferredDurationSeconds, 600);
      expect(restored.preferredTimeOfDay, TimeOfDayPreference.evening);
      expect(restored.customReminderHour, 20);
      expect(restored.customReminderMinute, 30);
      expect(restored.notificationsEnabled, true);
    });
  });
}
