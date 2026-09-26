import '../../../core/services/audio/audio_types.dart';
import '../../../data/models/breathing_pattern_model.dart';
import '../../../data/models/mood_entry_model.dart';
import '../../../data/models/session_model.dart';

enum SessionState {
  idle,
  preparing,
  playing,
  paused,
  completed,
  cancelled,
  error,
}

enum BreathingPhase {
  inhale('Breathe in...', 1.0, 1.45),
  holdAfterInhale('Hold...', 1.45, 1.45),
  exhale('Breathe out...', 1.45, 1.0),
  holdAfterExhale('Hold...', 1.0, 1.0);

  const BreathingPhase(this.label, this.startScale, this.endScale);
  final String label;
  final double startScale;
  final double endScale;
}

class SessionPlaybackState {
  const SessionPlaybackState({
    this.state = SessionState.idle,
    this.session,
    this.breathingPattern,
    this.elapsedSeconds = 0,
    this.totalSeconds = 0,
    this.currentGuidanceStep,
    this.currentInstruction = '',
    this.currentSubtext,
    this.breathingPhase = BreathingPhase.inhale,
    this.breathingPhaseProgress = 0.0,
    this.isMuted = false,
    this.volume = 1.0,
    this.audioSnapshot = const AudioSessionSnapshot(),
    this.errorMessage,
    this.moodBefore,
    this.moodAfter,
    this.sessionRecordId,
    this.startedAt,
    this.completedAt,
  });

  final SessionState state;
  final Session? session;
  final BreathingPattern? breathingPattern;
  final int elapsedSeconds;
  final int totalSeconds;
  final GuidanceStep? currentGuidanceStep;
  final String currentInstruction;
  final String? currentSubtext;
  final BreathingPhase breathingPhase;
  final double breathingPhaseProgress; // 0.0 to 1.0 in current phase
  final bool isMuted;
  final double volume;
  final AudioSessionSnapshot audioSnapshot;
  final String? errorMessage;
  final MoodType? moodBefore;
  final ReflectionMood? moodAfter;
  final String? sessionRecordId;
  final DateTime? startedAt;
  final DateTime? completedAt;

  int get remainingSeconds => (totalSeconds - elapsedSeconds).clamp(0, totalSeconds);

  double get progress {
    if (totalSeconds <= 0) return 0.0;
    return (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  bool get isPlaying => state == SessionState.playing;
  bool get isPaused => state == SessionState.paused;
  bool get isCompleted => state == SessionState.completed;
  bool get isCancelled => state == SessionState.cancelled;
  bool get hasEnded =>
      state == SessionState.completed ||
      state == SessionState.cancelled ||
      state == SessionState.error;

  bool get hasNarration => audioSnapshot.hasNarration;
  bool get hasAmbient => audioSnapshot.hasAmbient;
  bool get isFallbackMode => audioSnapshot.isFallbackMode;
  bool get isAudioPlaying => audioSnapshot.isPlaying;

  SessionPlaybackState copyWith({
    SessionState? state,
    Session? session,
    BreathingPattern? breathingPattern,
    int? elapsedSeconds,
    int? totalSeconds,
    GuidanceStep? currentGuidanceStep,
    String? currentInstruction,
    String? currentSubtext,
    BreathingPhase? breathingPhase,
    double? breathingPhaseProgress,
    bool? isMuted,
    double? volume,
    AudioSessionSnapshot? audioSnapshot,
    String? errorMessage,
    MoodType? moodBefore,
    ReflectionMood? moodAfter,
    String? sessionRecordId,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return SessionPlaybackState(
      state: state ?? this.state,
      session: session ?? this.session,
      breathingPattern: breathingPattern ?? this.breathingPattern,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      currentGuidanceStep: currentGuidanceStep ?? this.currentGuidanceStep,
      currentInstruction: currentInstruction ?? this.currentInstruction,
      currentSubtext: currentSubtext ?? this.currentSubtext,
      breathingPhase: breathingPhase ?? this.breathingPhase,
      breathingPhaseProgress: breathingPhaseProgress ?? this.breathingPhaseProgress,
      isMuted: isMuted ?? this.isMuted,
      volume: volume ?? this.volume,
      audioSnapshot: audioSnapshot ?? this.audioSnapshot,
      errorMessage: errorMessage ?? this.errorMessage,
      moodBefore: moodBefore ?? this.moodBefore,
      moodAfter: moodAfter ?? this.moodAfter,
      sessionRecordId: sessionRecordId ?? this.sessionRecordId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
