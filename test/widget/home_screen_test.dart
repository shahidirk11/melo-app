import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/mood_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/home/presentation/home_screen.dart';

void main() {
  group('HomeScreen & Recommendation Widget Tests', () {
    late InMemorySessionRepository sessionRepo;
    late InMemoryMoodRepository moodRepo;
    late InMemoryProgressRepository progressRepo;
    late InMemoryUserPreferencesRepository userRepo;

    setUp(() {
      sessionRepo = InMemorySessionRepository();
      moodRepo = InMemoryMoodRepository();
      progressRepo = InMemoryProgressRepository();
      userRepo = InMemoryUserPreferencesRepository(
        initial: const UserPreferences(
          firstName: 'Shahzad',
          onboardingCompleted: true,
        ),
      );
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(sessionRepo),
          moodRepositoryProvider.overrideWithValue(moodRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          userPreferencesRepositoryProvider.overrideWithValue(userRepo),
          audioServiceProvider.overrideWithValue(InMemoryAudioService()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: HomeScreen(),
          ),
        ),
      );
    }

    testWidgets('Renders personalized greeting, mood choices, and daily reset card',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      // Wait for FutureProvider to resolve
      await tester.pumpAndSettle();

      // 1. Verify personalized greeting containing first name
      expect(find.textContaining('Shahzad'), findsOneWidget);

      // 2. Verify all 5 mood options are displayed
      expect(find.text('😌 Calm'), findsOneWidget);
      expect(find.text('🙂 Good'), findsOneWidget);
      expect(find.text('😐 Okay'), findsOneWidget);
      expect(find.text('😟 Stressed'), findsOneWidget);
      expect(find.text('😴 Tired'), findsOneWidget);

      // 3. Verify Daily Reset Hero Card sections exist
      expect(find.text('Recommended for you'), findsOneWidget);
      expect(find.text('Start reset'), findsOneWidget);

      // 4. Verify Quick Resets are rendered
      expect(find.text('Quick Resets'), findsOneWidget);

      // 5. Verify Today's Practice card
      expect(find.text('Today\'s Practice'), findsOneWidget);
      expect(find.text('No practice yet today'), findsOneWidget);
    });

    testWidgets('Tapping Stressed mood persists selection and updates recommendation',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap '😟 Stressed'
      await tester.tap(find.text('😟 Stressed'));
      await tester.pumpAndSettle();

      // Verify mood was persisted to repository
      final latest = await moodRepo.getLatestMood();
      expect(latest?.mood, MoodType.stressed);

      // Verify recommendation reason reflects calming guidance
      expect(
        find.textContaining('tension'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping Tired mood persists selection and shifts recommendation to restorative rest',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap '😴 Tired'
      await tester.tap(find.text('😴 Tired'));
      await tester.pumpAndSettle();

      // Verify mood was persisted
      final latest = await moodRepo.getLatestMood();
      expect(latest?.mood, MoodType.tired);

      // Verify recommendation reason reflects restorative unwinding
      expect(
        find.textContaining('restorative'),
        findsOneWidget,
      );
    });
  });
}
