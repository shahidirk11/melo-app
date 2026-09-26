import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/app.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';

void main() {
  group('App Foundation & Shell Navigation Tests', () {
    testWidgets('Boots directly to Home when onboarding is already completed',
        (tester) async {
      final userRepo = InMemoryUserPreferencesRepository(
        initial: const UserPreferences(onboardingCompleted: true),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userPreferencesRepositoryProvider.overrideWithValue(userRepo),
            audioServiceProvider.overrideWithValue(InMemoryAudioService()),
          ],
          child: const MeloApp(),
        ),
      );

      // Advance past the splash timer (1400ms)
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      // Verify that Home screen elements are rendered
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('YOUR DAILY RESET'), findsOneWidget);

      // Tap on Explore tab
      await tester.tap(find.text('Explore'));
      await tester.pumpAndSettle();

      // Verify Explore header is present
      expect(find.text('Mindful practices for every part of your day'), findsOneWidget);

      // Tap on Progress tab
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      // Verify Progress header is present
      expect(find.text('Your Journey'), findsOneWidget);

      // Tap on Profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Verify Profile header is present
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('APPEARANCE'), findsOneWidget);
    });
  });
}
