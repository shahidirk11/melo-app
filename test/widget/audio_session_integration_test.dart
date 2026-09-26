import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/core/services/audio/audio_types.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/data/models/app_settings_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/app_settings_repository.dart';
import 'package:melo_app/data/repositories/breathing_pattern_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/sessions/presentation/active_session_screen.dart';
import 'package:melo_app/features/sessions/presentation/session_provider.dart';

void main() {
  group('ActiveSessionScreen Audio & Controls Integration Widget Tests', () {
    late InMemorySessionRepository sessionRepo;
    late InMemoryProgressRepository progressRepo;
    late InMemoryBreathingPatternRepository breathingRepo;
    late InMemoryUserPreferencesRepository userRepo;
    late InMemoryAppSettingsRepository settingsRepo;
    late InMemoryAudioService audioService;

    setUp(() {
      sessionRepo = InMemorySessionRepository();
      progressRepo = InMemoryProgressRepository();
      breathingRepo = InMemoryBreathingPatternRepository();
      userRepo = InMemoryUserPreferencesRepository();
      settingsRepo = InMemoryAppSettingsRepository();
      audioService = InMemoryAudioService();
    });

    Widget buildTestHarness({
      String sessionId = 'session_1m_reset',
      bool backgroundAudioEnabled = true,
    }) {
      settingsRepo = InMemoryAppSettingsRepository(
        initialSettings: AppSettings(backgroundAudioEnabled: backgroundAudioEnabled),
      );

      return ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(sessionRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          breathingPatternRepositoryProvider.overrideWithValue(breathingRepo),
          userPreferencesRepositoryProvider.overrideWithValue(userRepo),
          appSettingsRepositoryProvider.overrideWithValue(settingsRepo),
          audioServiceProvider.overrideWithValue(audioService),
        ],
        child: MaterialApp(
          home: ActiveSessionScreen(sessionId: sessionId),
        ),
      );
    }

    testWidgets('Displays audio mode badge, mute toggle, and volume button',
        (tester) async {
      await tester.pumpWidget(buildTestHarness());
      await tester.pumpAndSettle();

      // Tap Begin on intro modal to enter active session
      expect(find.text('Begin Session'), findsOneWidget);
      await tester.tap(find.text('Begin Session'));
      await tester.pumpAndSettle();

      // Audio badge is displayed
      expect(find.byType(ActiveSessionScreen), findsOneWidget);
      expect(find.byTooltip('Volume adjustment'), findsOneWidget);
      expect(find.byTooltip('Mute'), findsOneWidget);
      expect(find.byTooltip('Rewind 10 seconds'), findsOneWidget);
      expect(find.byTooltip('Skip 10 seconds'), findsOneWidget);
    });

    testWidgets('Tapping mute icon toggles mute on AudioService',
        (tester) async {
      await tester.pumpWidget(buildTestHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Session'));
      await tester.pumpAndSettle();

      // Initially unmuted
      expect(audioService.currentSnapshot.isMuted, false);
      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

      // Tap mute
      await tester.tap(find.byTooltip('Mute'));
      await tester.pumpAndSettle();

      expect(audioService.currentSnapshot.isMuted, true);
      expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);

      // Tap unmute
      await tester.tap(find.byTooltip('Unmute'));
      await tester.pumpAndSettle();

      expect(audioService.currentSnapshot.isMuted, false);
      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
    });

    testWidgets('Volume adjustment sheet opens and adjusts volume level',
        (tester) async {
      await tester.pumpWidget(buildTestHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Session'));
      await tester.pumpAndSettle();

      // Tap volume adjustment button
      await tester.tap(find.byTooltip('Volume adjustment'));
      await tester.pumpAndSettle();

      // Sheet opens
      expect(find.text('Audio Volume'), findsOneWidget);
      expect(find.byType(Slider), findsWidgets);

      // Close sheet
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
    });

    testWidgets('Rewind and Skip 10s buttons seek the session and audio',
        (tester) async {
      await tester.pumpWidget(buildTestHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Session'));
      await tester.pumpAndSettle();

      // Tap forward 10s
      await tester.tap(find.byTooltip('Skip 10 seconds'));
      await tester.pumpAndSettle();

      expect(audioService.currentSnapshot.position, const Duration(seconds: 10));

      // Tap forward 10s again
      await tester.tap(find.byTooltip('Skip 10 seconds'));
      await tester.pumpAndSettle();

      expect(audioService.currentSnapshot.position, const Duration(seconds: 20));

      // Tap rewind 10s
      await tester.tap(find.byTooltip('Rewind 10 seconds'));
      await tester.pumpAndSettle();

      expect(audioService.currentSnapshot.position, const Duration(seconds: 10));
    });

    testWidgets('Pauses playback when app backgrounds if background audio is disabled',
        (tester) async {
      await tester.pumpWidget(buildTestHarness(backgroundAudioEnabled: false));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Session'));
      await tester.pumpAndSettle();

      expect(audioService.currentSnapshot.isPlaying, true);

      // Trigger app backgrounding (paused)
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();

      // When background audio is disabled, session pauses
      expect(audioService.currentSnapshot.isPlaying, false);
      expect(audioService.currentSnapshot.isPaused, true);
    });

    testWidgets('Continues playback when app backgrounds if background audio is enabled',
        (tester) async {
      await tester.pumpWidget(buildTestHarness(backgroundAudioEnabled: true));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Session'));
      await tester.pumpAndSettle();

      expect(audioService.currentSnapshot.isPlaying, true);

      // Trigger app backgrounding (paused)
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();

      // When background audio is enabled, session keeps playing
      expect(audioService.currentSnapshot.isPlaying, true);
    });

    testWidgets('Completing session early stops audio and cleans up',
        (tester) async {
      await tester.pumpWidget(buildTestHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Session'));
      await tester.pumpAndSettle();

      expect(audioService.currentSnapshot.isPlaying, true);

      // Tap complete session early
      await tester.tap(find.byTooltip('Complete session early'));
      await tester.pumpAndSettle();

      // Audio stopped
      expect(audioService.currentSnapshot.isPlaying, false);
      expect(audioService.currentSnapshot.position, Duration.zero);
    });
  });
}
