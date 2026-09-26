import '../../../data/models/breathing_pattern_model.dart';
import 'session_state.dart';

class BreathingPhaseInfo {
  const BreathingPhaseInfo({
    required this.phase,
    required this.phaseSecondsElapsed,
    required this.phaseTotalSeconds,
    required this.phaseProgress,
    required this.currentScale,
    required this.cycleNumber,
  });

  final BreathingPhase phase;
  final int phaseSecondsElapsed;
  final int phaseTotalSeconds;
  final double phaseProgress; // 0.0 to 1.0
  final double currentScale;
  final int cycleNumber;
}

class BreathingCalculator {
  const BreathingCalculator();

  BreathingPhaseInfo calculatePhase({
    required BreathingPattern pattern,
    required int elapsedSeconds,
  }) {
    final cycleDuration = pattern.cycleDurationSeconds;
    if (cycleDuration <= 0) {
      return const BreathingPhaseInfo(
        phase: BreathingPhase.inhale,
        phaseSecondsElapsed: 0,
        phaseTotalSeconds: 4,
        phaseProgress: 0.0,
        currentScale: 1.0,
        cycleNumber: 1,
      );
    }

    final cycleNumber = (elapsedSeconds ~/ cycleDuration) + 1;
    final secondInCycle = elapsedSeconds % cycleDuration;

    final inhaleEnd = pattern.inhaleSeconds;
    final hold1End = inhaleEnd + pattern.holdAfterInhaleSeconds;
    final exhaleEnd = hold1End + pattern.exhaleSeconds;

    if (secondInCycle < inhaleEnd) {
      final elapsedInPhase = secondInCycle;
      final total = pattern.inhaleSeconds;
      final progress = total > 0 ? (elapsedInPhase / total).clamp(0.0, 1.0) : 1.0;
      final scale = 1.0 + (progress * 0.45); // 1.0 -> 1.45
      return BreathingPhaseInfo(
        phase: BreathingPhase.inhale,
        phaseSecondsElapsed: elapsedInPhase,
        phaseTotalSeconds: total,
        phaseProgress: progress,
        currentScale: scale,
        cycleNumber: cycleNumber,
      );
    } else if (secondInCycle < hold1End) {
      final elapsedInPhase = secondInCycle - inhaleEnd;
      final total = pattern.holdAfterInhaleSeconds;
      final progress = total > 0 ? (elapsedInPhase / total).clamp(0.0, 1.0) : 1.0;
      return BreathingPhaseInfo(
        phase: BreathingPhase.holdAfterInhale,
        phaseSecondsElapsed: elapsedInPhase,
        phaseTotalSeconds: total,
        phaseProgress: progress,
        currentScale: 1.45,
        cycleNumber: cycleNumber,
      );
    } else if (secondInCycle < exhaleEnd) {
      final elapsedInPhase = secondInCycle - hold1End;
      final total = pattern.exhaleSeconds;
      final progress = total > 0 ? (elapsedInPhase / total).clamp(0.0, 1.0) : 1.0;
      final scale = 1.45 - (progress * 0.45); // 1.45 -> 1.0
      return BreathingPhaseInfo(
        phase: BreathingPhase.exhale,
        phaseSecondsElapsed: elapsedInPhase,
        phaseTotalSeconds: total,
        phaseProgress: progress,
        currentScale: scale,
        cycleNumber: cycleNumber,
      );
    } else {
      final elapsedInPhase = secondInCycle - exhaleEnd;
      final total = pattern.holdAfterExhaleSeconds;
      final progress = total > 0 ? (elapsedInPhase / total).clamp(0.0, 1.0) : 1.0;
      return BreathingPhaseInfo(
        phase: BreathingPhase.holdAfterExhale,
        phaseSecondsElapsed: elapsedInPhase,
        phaseTotalSeconds: total,
        phaseProgress: progress,
        currentScale: 1.0,
        cycleNumber: cycleNumber,
      );
    }
  }
}
