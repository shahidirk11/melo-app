import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/app.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/onboarding/presentation/onboarding_screen.dart';

void main() {
  group('Onboarding Flow Widget Tests', () {
    testWidgets('New user (first install) routes to Onboarding from Splash',
        (tester) async {
      final userRepo = InMemoryUserPreferencesRepository(
        initial: const UserPreferences(onboardingCompleted: false),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userPreferencesRepositoryProvider.overrideWithValue(userRepo),
          ],
          child: const MeloApp(),
        ),
      );

      // Advance past splash delay (1400ms)
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      // Verify that Onboarding welcome screen is rendered
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
    });

    testWidgets('Returning user automatically skips onboarding and lands on Home',
        (tester) async {
      final userRepo = InMemoryUserPreferencesRepository(
        initial: const UserPreferences(onboardingCompleted: true),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userPreferencesRepositoryProvider.overrideWithValue(userRepo),
          ],
          child: const MeloApp(),
        ),
      );

      // Advance past splash delay
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      // Verify user lands directly on Home, skipping onboarding
      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.text('YOUR DAILY RESET'), findsOneWidget);
    });

    testWidgets('Step navigation and back navigation work smoothly across steps',
        (tester) async {
      final userRepo = InMemoryUserPreferencesRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userPreferencesRepositoryProvider.overrideWithValue(userRepo),
          ],
          child: const MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Step 1: Welcome
      expect(find.text('Get started'), findsOneWidget);
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();

      // Step 2: Goals
      expect(find.text('What would you like help with?'), findsOneWidget);
      expect(find.text('Feel calmer'), findsOneWidget);
      expect(find.text('Sleep better'), findsOneWidget);

      // Select 'Sleep better' as an additional goal
      await tester.tap(find.text('Sleep better'));
      await tester.pumpAndSettle();

      // Test Back navigation: back button must return to Step 1
      expect(find.byTooltip('Back to previous step'), findsOneWidget);
      await tester.tap(find.byTooltip('Back to previous step'));
      await tester.pumpAndSettle();

      // We are back at Step 1
      expect(find.text('Get started'), findsOneWidget);

      // Advance forward again
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();

      // Proceed to Step 3 (Duration)
      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 3: Duration
      expect(find.text('How much time do you usually have?'), findsOneWidget);
      expect(find.text('5 minutes'), findsOneWidget);
      expect(find.text('10 minutes'), findsOneWidget);

      // Pick '10 minutes'
      await tester.tap(find.text('10 minutes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 4: Reminder time
      expect(find.text('When would you like your daily reset?'), findsOneWidget);
      expect(find.text('Morning'), findsOneWidget);
      expect(find.text('Evening'), findsOneWidget);

      // Pick 'Evening'
      await tester.tap(find.text('Evening'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 5: Notification explanation
      expect(find.text('A gentle nudge when it\'s time'), findsOneWidget);
      expect(find.text('Always supportive, never guilt-inducing'), findsOneWidget);
      expect(find.text('Enable reminders'), findsOneWidget);
      expect(find.text('Not now'), findsOneWidget);

      // Tap 'Enable reminders'
      await tester.tap(find.text('Enable reminders'));
      await tester.pumpAndSettle();

      // Step 6: First session invitation
      expect(find.text('Ready for your first reset?'), findsOneWidget);
      expect(find.text('Start first session'), findsOneWidget);
      expect(find.text('Explore home first'), findsOneWidget);

      // Tap 'Explore home first'
      await tester.tap(find.text('Explore home first'));
      await tester.pumpAndSettle();

      // Verify that onboarding is marked completed in repository
      final savedPrefs = await userRepo.getPreferences();
      expect(savedPrefs.onboardingCompleted, true);
      expect(savedPrefs.preferredDurationSeconds, 600); // 10 minutes selected earlier
      expect(savedPrefs.preferredTimeOfDay, TimeOfDayPreference.evening);
      expect(savedPrefs.notificationsEnabled, true);
    });
  });
}
