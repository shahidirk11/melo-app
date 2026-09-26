import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/breathing_pattern_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/sessions/domain/session_state.dart';
import 'package:melo_app/features/sessions/presentation/active_session_screen.dart';
import 'package:melo_app/features/sessions/presentation/session_completion_screen.dart';
import 'package:melo_app/features/sessions/presentation/session_provider.dart';
import 'package:melo_app/features/sessions/presentation/widgets/breathing_circle_visualizer.dart';

void main() {
  group('ActiveSessionScreen & SessionCompletionScreen Widget Tests', () {
    late InMemorySessionRepository sessionRepo;
    late InMemoryProgressRepository progressRepo;
    late InMemoryBreathingPatternRepository breathingRepo;
    late InMemoryUserPreferencesRepository userRepo;

    setUp(() {
      sessionRepo = InMemorySessionRepository();
      progressRepo = InMemoryProgressRepository();
      breathingRepo = InMemoryBreathingPatternRepository();
      userRepo = InMemoryUserPreferencesRepository();
    });

    Widget createActiveSessionWidget({String sessionId = 'session_1m_reset'}) {
      return ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(sessionRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          breathingPatternRepositoryProvider.overrideWithValue(breathingRepo),
          userPreferencesRepositoryProvider.overrideWithValue(userRepo),
          audioServiceProvider.overrideWithValue(InMemoryAudioService()),
        ],
        child: MaterialApp(
          home: ActiveSessionScreen(sessionId: sessionId),
        ),
      );
    }

    Widget createCompletionWidget({String sessionId = 'session_1m_reset'}) {
      return ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(sessionRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
        ],
        child: MaterialApp(
          home: SessionCompletionScreen(sessionId: sessionId),
        ),
      );
    }

    testWidgets('ActiveSessionScreen displays Intro Dialog and starts session on Begin tap',
        (tester) async {
      await tester.pumpWidget(createActiveSessionWidget());
      await tester.pumpAndSettle();

      // Verify Intro Dialog renders
      expect(find.text('One Minute Reset'), findsOneWidget);
      expect(find.text('Begin reset'), findsOneWidget);
      expect(find.text('Sit somewhere comfortable and soften your gaze.'), findsOneWidget);

      // Tap 'Begin reset'
      await tester.tap(find.text('Begin reset'));
      await tester.pumpAndSettle();

      // Verify active session controls and timer are displayed
      expect(find.byType(BreathingCircleVisualizer), findsOneWidget);
      expect(find.text('CALM'), findsOneWidget);
      expect(find.byTooltip('Pause'), findsOneWidget);
      expect(find.byTooltip('Leave session'), findsOneWidget);
    });

    testWidgets('Exit confirmation dialog displays when attempting to leave active session',
        (tester) async {
      await tester.pumpWidget(createActiveSessionWidget());
      await tester.pumpAndSettle();

      // Begin session
      await tester.tap(find.text('Begin reset'));
      await tester.pumpAndSettle();

      // Tap exit button
      await tester.tap(find.byTooltip('Leave session'));
      await tester.pumpAndSettle();

      // Verify Exit Confirmation dialog
      expect(find.text('Leave session?'), findsOneWidget);
      expect(find.text('You\'ll lose this session\'s current progress.'), findsOneWidget);
      expect(find.text('Leave'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Tap 'Continue' to stay
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Verify still in active session
      expect(find.byType(BreathingCircleVisualizer), findsOneWidget);
    });

    testWidgets('BreathingCircleVisualizer handles reduced motion setting',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: BreathingCircleVisualizer(
                phase: BreathingPhase.inhale,
                remainingFormatted: '00:45',
                isReducedMotion: true,
                isPlaying: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('00:45'), findsOneWidget);
      expect(find.text('Breathe in...'), findsOneWidget);
    });

    testWidgets('SessionCompletionScreen renders celebration, reflection choices, and Done button',
        (tester) async {
      await tester.pumpWidget(createCompletionWidget());
      await tester.pumpAndSettle();

      // Verify celebration
      expect(find.text('Nice work'), findsOneWidget);
      expect(find.text('How do you feel now?'), findsOneWidget);

      // Verify reflection options
      expect(find.text('🙂 Better'), findsOneWidget);
      expect(find.text('😐 About the same'), findsOneWidget);
      expect(find.text('😌 More relaxed'), findsOneWidget);
      expect(find.text('😕 Still unsettled'), findsOneWidget);

      // Tap reflection
      await tester.tap(find.text('😌 More relaxed'));
      await tester.pumpAndSettle();

      // Verify Done CTA
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Try another reset'), findsOneWidget);
    });
  });
}
