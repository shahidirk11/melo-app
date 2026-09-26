import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/services/audio/audio_service.dart';
import '../../../core/services/audio/audio_types.dart';
import '../../../data/models/breathing_pattern_model.dart';
import '../../../data/models/mood_entry_model.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/session_record_model.dart';
import '../../../data/repositories/breathing_pattern_repository.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/repositories/session_repository.dart';
import '../domain/breathing_calculator.dart';
import '../domain/session_state.dart';

final breathingCalculatorProvider = Provider<BreathingCalculator>((ref) {
  return const BreathingCalculator();
});

class SessionEngineNotifier extends StateNotifier<SessionPlaybackState> {
  SessionEngineNotifier({
    required this.sessionRepository,
    required this.progressRepository,
    required this.breathingPatternRepository,
    required this.calculator,
    AudioService? audioService,
    this.allowBackgroundAudio = true,
  })  : audioService = audioService ?? InMemoryAudioService(),
        super(const SessionPlaybackState()) {
    _listenToAudioService();
  }

  final SessionRepository sessionRepository;
  final ProgressRepository progressRepository;
  final BreathingPatternRepository breathingPatternRepository;
  final BreathingCalculator calculator;
  final AudioService audioService;
  final bool allowBackgroundAudio;

  Timer? _ticker;
  StreamSubscription<AudioSessionSnapshot>? _audioSubscription;

  void _listenToAudioService() {
    _audioSubscription = audioService.stateStream.listen((snapshot) {
      state = state.copyWith(
        audioSnapshot: snapshot,
        isMuted: snapshot.isMuted,
        volume: snapshot.masterVolume,
      );
    });
  }

  Future<void> initSession(String sessionId, {MoodType? moodBefore}) async {
    _ticker?.cancel();
    state = const SessionPlaybackState(state: SessionState.preparing);

    final session = await sessionRepository.getSessionById(sessionId);
    if (session == null) {
      state = state.copyWith(
        state: SessionState.error,
        errorMessage: 'Session could not be loaded.',
      );
      return;
    }

    BreathingPattern? pattern;
    if (session.category == SessionCategory.breathing ||
        session.type == SessionType.breathing) {
      if (session.tags.contains('4-7-8') || session.title.contains('Night')) {
        pattern = BreathingPattern.relaxingBreath;
      } else if (session.tags.contains('box')) {
        pattern = BreathingPattern.boxBreathing;
      } else {
        pattern = BreathingPattern.simpleSlow;
      }
    }

    final initialStep = session.guidanceSteps.isNotEmpty
        ? session.guidanceSteps.first
        : null;

    // Prepare audio tracks with graceful fallback if unavailable
    await audioService.prepareSessionAudio(
      narrationAsset: session.audioAsset,
      ambientAsset: session.backgroundSoundAsset,
      allowBackground: allowBackgroundAudio,
    );

    state = SessionPlaybackState(
      state: SessionState.idle,
      session: session,
      breathingPattern: pattern,
      elapsedSeconds: 0,
      totalSeconds: session.durationSeconds,
      currentGuidanceStep: initialStep,
      currentInstruction: initialStep?.instruction ?? 'Find a comfortable space and breathe.',
      currentSubtext: initialStep?.subtext,
      audioSnapshot: audioService.currentSnapshot,
      moodBefore: moodBefore,
    );
  }

  Future<void> start() async {
    if (state.session == null) return;
    state = state.copyWith(
      state: SessionState.playing,
      startedAt: DateTime.now(),
    );
    await audioService.play();
    _startTicker();
  }

  Future<void> pause() async {
    if (state.state != SessionState.playing) return;
    _ticker?.cancel();
    await audioService.pause();
    state = state.copyWith(state: SessionState.paused);
  }

  Future<void> resume() async {
    if (state.state != SessionState.paused) return;
    state = state.copyWith(state: SessionState.playing);
    await audioService.resume();
    _startTicker();
  }

  Future<void> restart() async {
    _ticker?.cancel();
    final firstStep = state.session?.guidanceSteps.isNotEmpty == true
        ? state.session!.guidanceSteps.first
        : null;

    state = state.copyWith(
      state: SessionState.playing,
      elapsedSeconds: 0,
      currentGuidanceStep: firstStep,
      currentInstruction: firstStep?.instruction ?? 'Find a comfortable space and breathe.',
      currentSubtext: firstStep?.subtext,
      breathingPhase: BreathingPhase.inhale,
      breathingPhaseProgress: 0.0,
      startedAt: DateTime.now(),
    );
    await audioService.seek(Duration.zero);
    await audioService.play();
    _startTicker();
  }

  Future<void> seek(int seconds) async {
    final clamped = seconds.clamp(0, state.totalSeconds);
    await audioService.seek(Duration(seconds: clamped));

    GuidanceStep? currentStep = state.currentGuidanceStep;
    final steps = state.session?.guidanceSteps ?? [];
    for (final step in steps) {
      final start = step.startSecond;
      final end = start + step.durationSeconds;
      if (clamped >= start && clamped < end) {
        currentStep = step;
        break;
      }
    }

    BreathingPhase phase = state.breathingPhase;
    double progress = state.breathingPhaseProgress;
    if (state.breathingPattern != null) {
      final phaseInfo = calculator.calculatePhase(
        pattern: state.breathingPattern!,
        elapsedSeconds: clamped,
      );
      phase = phaseInfo.phase;
      progress = phaseInfo.phaseProgress;
    }

    state = state.copyWith(
      elapsedSeconds: clamped,
      currentGuidanceStep: currentStep,
      currentInstruction: currentStep?.instruction ?? phase.label,
      currentSubtext: currentStep?.subtext,
      breathingPhase: phase,
      breathingPhaseProgress: progress,
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.state != SessionState.playing) return;

      final newElapsed = state.elapsedSeconds + 1;
      final total = state.totalSeconds;

      if (newElapsed >= total) {
        finish(wasCompleted: true);
        return;
      }

      // Update guidance step based on new elapsed seconds
      GuidanceStep? currentStep = state.currentGuidanceStep;
      final steps = state.session?.guidanceSteps ?? [];
      for (final step in steps) {
        final start = step.startSecond;
        final end = start + step.durationSeconds;
        if (newElapsed >= start && newElapsed < end) {
          currentStep = step;
          break;
        }
      }

      // Update breathing phase if pattern is attached
      BreathingPhase phase = state.breathingPhase;
      double progress = state.breathingPhaseProgress;
      if (state.breathingPattern != null) {
        final phaseInfo = calculator.calculatePhase(
          pattern: state.breathingPattern!,
          elapsedSeconds: newElapsed,
        );
        phase = phaseInfo.phase;
        progress = phaseInfo.phaseProgress;
      }

      state = state.copyWith(
        elapsedSeconds: newElapsed,
        currentGuidanceStep: currentStep,
        currentInstruction: currentStep?.instruction ?? phase.label,
        currentSubtext: currentStep?.subtext,
        breathingPhase: phase,
        breathingPhaseProgress: progress,
      );
    });
  }

  Future<void> finish({required bool wasCompleted}) async {
    _ticker?.cancel();
    await audioService.stop();

    final session = state.session;
    final now = DateTime.now();
    final started = state.startedAt ?? now.subtract(Duration(seconds: state.elapsedSeconds));

    String? recordId;
    if (session != null) {
      recordId = 'record_${now.millisecondsSinceEpoch}';
      final record = SessionRecord(
        id: recordId,
        sessionId: session.id,
        sessionTitle: session.title,
        sessionType: session.type,
        startedAt: started,
        completedAt: now,
        durationCompletedSeconds: state.elapsedSeconds,
        wasCompleted: wasCompleted,
        moodBefore: state.moodBefore,
      );
      await progressRepository.recordSession(record);
    }

    state = state.copyWith(
      state: wasCompleted ? SessionState.completed : SessionState.cancelled,
      completedAt: now,
      sessionRecordId: recordId,
    );
  }

  Future<void> recordReflection(ReflectionMood moodAfter) async {
    state = state.copyWith(moodAfter: moodAfter);
    final recordId = state.sessionRecordId;
    if (recordId != null) {
      final existing = await progressRepository.getRecordById(recordId);
      if (existing != null) {
        final updated = SessionRecord(
          id: existing.id,
          sessionId: existing.sessionId,
          sessionTitle: existing.sessionTitle,
          sessionType: existing.sessionType,
          startedAt: existing.startedAt,
          completedAt: existing.completedAt,
          durationCompletedSeconds: existing.durationCompletedSeconds,
          wasCompleted: existing.wasCompleted,
          moodBefore: existing.moodBefore,
          moodAfter: moodAfter,
        );
        // Overwrite updated record
        await progressRepository.deleteRecord(recordId);
        await progressRepository.recordSession(updated);
      }
    }
  }

  Future<void> toggleMute() async {
    final nextMute = !state.isMuted;
    await audioService.setMuted(nextMute);
    state = state.copyWith(isMuted: nextMute);
  }

  Future<void> setVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    await audioService.setMasterVolume(clamped);
    state = state.copyWith(volume: clamped);
  }

  Future<void> setNarrationVolume(double volume) async {
    await audioService.setNarrationVolume(volume);
  }

  Future<void> setAmbientVolume(double volume) async {
    await audioService.setAmbientVolume(volume);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _audioSubscription?.cancel();
    audioService.stop();
    super.dispose();
  }
}

final sessionEngineProvider =
    StateNotifierProvider.autoDispose<SessionEngineNotifier, SessionPlaybackState>((ref) {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  final breathingRepo = ref.watch(breathingPatternRepositoryProvider);
  final calculator = ref.watch(breathingCalculatorProvider);
  final audioService = ref.watch(audioServiceProvider);
  final appSettings = ref.watch(appSettingsProvider);

  return SessionEngineNotifier(
    sessionRepository: sessionRepo,
    progressRepository: progressRepo,
    breathingPatternRepository: breathingRepo,
    calculator: calculator,
    audioService: audioService,
    allowBackgroundAudio: appSettings.backgroundAudioEnabled,
  );
});
