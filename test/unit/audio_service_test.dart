import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/core/services/audio/audio_service.dart';
import 'package:melo_app/core/services/audio/audio_types.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/repositories/breathing_pattern_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/features/sessions/domain/breathing_calculator.dart';
import 'package:melo_app/features/sessions/domain/session_state.dart';
import 'package:melo_app/features/sessions/presentation/session_provider.dart';

void main() {
  group('AudioService & Session Engine Audio Integration Unit Tests', () {
    late InMemoryAudioService audioService;
    late InMemorySessionRepository sessionRepo;
    late InMemoryProgressRepository progressRepo;
    late InMemoryBreathingPatternRepository breathingRepo;
    late BreathingCalculator calculator;
    late SessionEngineNotifier engine;

    setUp(() {
      audioService = InMemoryAudioService();
      sessionRepo = InMemorySessionRepository();
      progressRepo = InMemoryProgressRepository();
      breathingRepo = InMemoryBreathingPatternRepository();
      calculator = const BreathingCalculator();

      engine = SessionEngineNotifier(
        sessionRepository: sessionRepo,
        progressRepository: progressRepo,
        breathingPatternRepository: breathingRepo,
        calculator: calculator,
        audioService: audioService,
        allowBackgroundAudio: true,
      );
    });

    tearDown(() {
      engine.dispose();
      audioService.dispose();
    });

    test('Prepares audio tracks properly when assets are present', () async {
      await audioService.prepareSessionAudio(
        narrationAsset: 'assets/audio/demo_narration.wav',
        ambientAsset: 'assets/audio/demo_ambient.wav',
      );

      final snapshot = audioService.currentSnapshot;
      expect(snapshot.hasNarration, true);
      expect(snapshot.hasAmbient, true);
      expect(snapshot.isFallbackMode, false);
      expect(snapshot.hasActiveAudio, true);
      expect(snapshot.position, Duration.zero);
    });

    test('Play, pause, resume, and stop cycle correctly updates status', () async {
      await audioService.prepareSessionAudio(
        narrationAsset: 'assets/audio/demo_narration.wav',
        ambientAsset: 'assets/audio/demo_ambient.wav',
      );

      // 1. Play
      await audioService.play();
      expect(audioService.currentSnapshot.isPlaying, true);
      expect(audioService.currentSnapshot.narrationStatus, AudioPlaybackStatus.playing);
      expect(audioService.currentSnapshot.ambientStatus, AudioPlaybackStatus.playing);

      // 2. Pause
      await audioService.pause();
      expect(audioService.currentSnapshot.isPlaying, false);
      expect(audioService.currentSnapshot.isPaused, true);
      expect(audioService.currentSnapshot.narrationStatus, AudioPlaybackStatus.paused);
      expect(audioService.currentSnapshot.ambientStatus, AudioPlaybackStatus.paused);

      // 3. Resume
      await audioService.resume();
      expect(audioService.currentSnapshot.isPlaying, true);
      expect(audioService.currentSnapshot.narrationStatus, AudioPlaybackStatus.playing);

      // 4. Stop
      await audioService.stop();
      expect(audioService.currentSnapshot.isPlaying, false);
      expect(audioService.currentSnapshot.narrationStatus, AudioPlaybackStatus.idle);
      expect(audioService.currentSnapshot.position, Duration.zero);
    });

    test('Seek moves audio position accurately across tracks', () async {
      await audioService.prepareSessionAudio(
        narrationAsset: 'assets/audio/demo_narration.wav',
      );
      await audioService.play();

      await audioService.seek(const Duration(seconds: 25));
      expect(audioService.currentSnapshot.position, const Duration(seconds: 25));

      await audioService.seek(const Duration(seconds: 50));
      expect(audioService.currentSnapshot.position, const Duration(seconds: 50));
    });

    test('Master volume, track volumes, and mute toggle operate independently', () async {
      await audioService.prepareSessionAudio(
        narrationAsset: 'assets/audio/demo_narration.wav',
        ambientAsset: 'assets/audio/demo_ambient.wav',
      );

      // Set master volume
      await audioService.setMasterVolume(0.8);
      expect(audioService.currentSnapshot.masterVolume, 0.8);

      // Set narration volume
      await audioService.setNarrationVolume(0.9);
      expect(audioService.currentSnapshot.narrationVolume, 0.9);

      // Set ambient volume
      await audioService.setAmbientVolume(0.4);
      expect(audioService.currentSnapshot.ambientVolume, 0.4);

      // Mute toggle
      await audioService.setMuted(true);
      expect(audioService.currentSnapshot.isMuted, true);

      await audioService.setMuted(false);
      expect(audioService.currentSnapshot.isMuted, false);
    });

    test('Audio interruption: pause pauses playback and resume restores playback', () async {
      await audioService.prepareSessionAudio(
        narrationAsset: 'assets/audio/demo_narration.wav',
      );
      await audioService.play();
      expect(audioService.currentSnapshot.isPlaying, true);

      // Incoming phone call triggers pause interruption
      await audioService.handleInterruption(AudioInterruptionAction.pause);
      expect(audioService.currentSnapshot.isPlaying, false);
      expect(audioService.currentSnapshot.isPaused, true);

      // Call ends triggers resume interruption
      await audioService.handleInterruption(AudioInterruptionAction.resume);
      expect(audioService.currentSnapshot.isPlaying, true);
    });

    test('Audio interruption: ducking temporarily reduces volume and unduck restores it', () async {
      await audioService.prepareSessionAudio(
        narrationAsset: 'assets/audio/demo_narration.wav',
        ambientAsset: 'assets/audio/demo_ambient.wav',
      );
      await audioService.play();

      // GPS/Notification ducks audio
      await audioService.handleInterruption(AudioInterruptionAction.duck);
      expect(audioService.currentSnapshot.narrationVolume, lessThan(1.0));
      expect(audioService.currentSnapshot.ambientVolume, lessThan(0.5));

      // Notification ends unducks audio
      await audioService.handleInterruption(AudioInterruptionAction.unduck);
      expect(audioService.currentSnapshot.narrationVolume, 1.0);
      expect(audioService.currentSnapshot.ambientVolume, 0.5);
    });

    test('Headphone disconnect (becoming noisy) pauses playback immediately', () async {
      await audioService.prepareSessionAudio(
        narrationAsset: 'assets/audio/demo_narration.wav',
      );
      await audioService.play();
      expect(audioService.currentSnapshot.isPlaying, true);

      // User unplugs headphones
      await audioService.handleHeadphonesDisconnected();
      expect(audioService.currentSnapshot.isPlaying, false);
      expect(audioService.currentSnapshot.isPaused, true);
    });

    test('Missing asset activates graceful fallback mode without crashing', () async {
      final fallbackService = InMemoryAudioService(simulateMissingAsset: true);

      await fallbackService.prepareSessionAudio(
        narrationAsset: 'assets/audio/missing_asset.mp3',
        ambientAsset: 'assets/audio/missing_ambient.mp3',
      );

      final snapshot = fallbackService.currentSnapshot;
      expect(snapshot.hasNarration, false);
      expect(snapshot.hasAmbient, false);
      expect(snapshot.isFallbackMode, true);
      expect(snapshot.errorMessage, isNull);

      // Calling play in fallback mode does not crash or throw
      await fallbackService.play();
      expect(snapshot.isFallbackMode, true);

      fallbackService.dispose();
    });

    test('SessionEngineNotifier coordinates audio lifecycle with session lifecycle', () async {
      await engine.initSession('session_1m_reset');
      expect(engine.state.state, SessionState.idle);

      // Start session starts audio
      await engine.start();
      expect(engine.state.state, SessionState.playing);
      expect(audioService.currentSnapshot.isPlaying, true);

      // Pause session pauses audio
      await engine.pause();
      expect(engine.state.state, SessionState.paused);
      expect(audioService.currentSnapshot.isPlaying, false);

      // Resume session resumes audio
      await engine.resume();
      expect(engine.state.state, SessionState.playing);
      expect(audioService.currentSnapshot.isPlaying, true);

      // Seek session seeks audio
      await engine.seek(30);
      expect(engine.state.elapsedSeconds, 30);
      expect(audioService.currentSnapshot.position, const Duration(seconds: 30));

      // Finish session stops audio
      await engine.finish(wasCompleted: true);
      expect(engine.state.state, SessionState.completed);
      expect(audioService.currentSnapshot.isPlaying, false);
      expect(audioService.currentSnapshot.position, Duration.zero);
    });

    test('Resource cleanup: disposing engine stops audio cleanly', () async {
      await engine.initSession('session_1m_reset');
      await engine.start();
      expect(audioService.currentSnapshot.isPlaying, true);

      // Disposing engine stops audio playback
      engine.dispose();
      expect(audioService.currentSnapshot.isPlaying, false);
    });
  });
}
