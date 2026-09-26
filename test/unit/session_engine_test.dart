import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/data/datasources/local_content_seed.dart';
import 'package:melo_app/data/models/breathing_pattern_model.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/repositories/breathing_pattern_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/features/sessions/domain/breathing_calculator.dart';
import 'package:melo_app/features/sessions/domain/session_state.dart';
import 'package:melo_app/features/sessions/presentation/session_provider.dart';

void main() {
  group('SessionEngine State Machine & Logic Unit Tests', () {
    late InMemorySessionRepository sessionRepo;
    late InMemoryProgressRepository progressRepo;
    late InMemoryBreathingPatternRepository breathingRepo;
    late BreathingCalculator calculator;
    late SessionEngineNotifier engine;

    setUp(() {
      sessionRepo = InMemorySessionRepository();
      progressRepo = InMemoryProgressRepository();
      breathingRepo = InMemoryBreathingPatternRepository();
      calculator = const BreathingCalculator();

      engine = SessionEngineNotifier(
        sessionRepository: sessionRepo,
        progressRepository: progressRepo,
        breathingPatternRepository: breathingRepo,
        calculator: calculator,
      );
    });

    tearDown(() {
      engine.dispose();
    });

    test('Initializes session properly into idle state with guidance steps', () async {
      await engine.initSession('session_1m_reset');

      expect(engine.state.state, SessionState.idle);
      expect(engine.state.session?.id, 'session_1m_reset');
      expect(engine.state.totalSeconds, 60);
      expect(engine.state.elapsedSeconds, 0);
      expect(engine.state.remainingSeconds, 60);
      expect(engine.state.currentInstruction, isNotEmpty);
    });

    test('Starts, pauses, resumes, and updates state cleanly', () async {
      await engine.initSession('session_1m_reset');

      // Start
      engine.start();
      expect(engine.state.state, SessionState.playing);
      expect(engine.state.isPlaying, true);

      // Pause
      engine.pause();
      expect(engine.state.state, SessionState.paused);
      expect(engine.state.isPaused, true);

      // Resume
      engine.resume();
      expect(engine.state.state, SessionState.playing);
      expect(engine.state.isPlaying, true);
    });

    test('Restart resets elapsed time and restarts from beginning', () async {
      await engine.initSession('session_1m_reset');
      engine.start();

      engine.restart();
      expect(engine.state.elapsedSeconds, 0);
      expect(engine.state.state, SessionState.playing);
      expect(engine.state.breathingPhase, BreathingPhase.inhale);
    });

    test('Normal completion records SessionRecord with wasCompleted: true', () async {
      await engine.initSession('session_1m_reset', moodBefore: MoodType.stressed);
      engine.start();

      // Finish with completion
      await engine.finish(wasCompleted: true);

      expect(engine.state.state, SessionState.completed);
      expect(engine.state.isCompleted, true);

      final history = await progressRepo.getHistory();
      expect(history.length, 1);
      final record = history.first;
      expect(record.sessionId, 'session_1m_reset');
      expect(record.wasCompleted, true);
      expect(record.moodBefore, MoodType.stressed);

      final stats = await progressRepo.getStats();
      expect(stats.totalSessions, 1);
    });

    test('Cancellation (abandoned session) records wasCompleted: false and is not counted in stats',
        () async {
      await engine.initSession('session_1m_reset');
      engine.start();

      // Abandon session
      await engine.finish(wasCompleted: false);

      expect(engine.state.state, SessionState.cancelled);
      expect(engine.state.isCancelled, true);

      final history = await progressRepo.getHistory();
      expect(history.length, 1);
      final record = history.first;
      expect(record.wasCompleted, false);

      // Verify abandoned session does NOT count toward stats
      final stats = await progressRepo.getStats();
      expect(stats.totalSessions, 0);
      expect(stats.totalMinutes, 0);
    });

    test('Reflection persistence updates SessionRecord with moodAfter', () async {
      await engine.initSession('session_1m_reset');
      engine.start();
      await engine.finish(wasCompleted: true);

      // Record reflection
      await engine.recordReflection(ReflectionMood.moreRelaxed);

      expect(engine.state.moodAfter, ReflectionMood.moreRelaxed);
      final history = await progressRepo.getHistory();
      expect(history.first.moodAfter, ReflectionMood.moreRelaxed);
    });

    test('Rapid interactions (rapid pause/resume/restart) do not throw or corrupt state', () async {
      await engine.initSession('session_1m_reset');
      engine.start();

      for (int i = 0; i < 20; i++) {
        engine.pause();
        engine.resume();
      }
      engine.restart();
      expect(engine.state.state, SessionState.playing);
      expect(engine.state.elapsedSeconds, 0);
    });

    test('BreathingCalculator transitions across Box Breathing phases accurately', () {
      const pattern = BreathingPattern.boxBreathing; // 4 in, 4 hold, 4 out, 4 hold = 16s cycle

      // Second 2 -> Inhale
      final p1 = calculator.calculatePhase(pattern: pattern, elapsedSeconds: 2);
      expect(p1.phase, BreathingPhase.inhale);
      expect(p1.currentScale, greaterThan(1.0));

      // Second 5 -> Hold after inhale
      final p2 = calculator.calculatePhase(pattern: pattern, elapsedSeconds: 5);
      expect(p2.phase, BreathingPhase.holdAfterInhale);
      expect(p2.currentScale, 1.45);

      // Second 10 -> Exhale
      final p3 = calculator.calculatePhase(pattern: pattern, elapsedSeconds: 10);
      expect(p3.phase, BreathingPhase.exhale);
      expect(p3.currentScale, lessThan(1.45));

      // Second 14 -> Hold after exhale
      final p4 = calculator.calculatePhase(pattern: pattern, elapsedSeconds: 14);
      expect(p4.phase, BreathingPhase.holdAfterExhale);
      expect(p4.currentScale, 1.0);
    });
  });
}
