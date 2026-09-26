import 'package:equatable/equatable.dart';

class BreathingPattern extends Equatable {
  const BreathingPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.inhaleSeconds,
    required this.holdAfterInhaleSeconds,
    required this.exhaleSeconds,
    required this.holdAfterExhaleSeconds,
    this.totalCycles = 4,
  });

  final String id;
  final String name;
  final String description;
  final int inhaleSeconds;
  final int holdAfterInhaleSeconds;
  final int exhaleSeconds;
  final int holdAfterExhaleSeconds;
  final int totalCycles;

  int get cycleDurationSeconds =>
      inhaleSeconds + holdAfterInhaleSeconds + exhaleSeconds + holdAfterExhaleSeconds;

  int get totalDurationSeconds => cycleDurationSeconds * totalCycles;

  static const BreathingPattern boxBreathing = BreathingPattern(
    id: 'box_breathing',
    name: 'Box Breathing',
    description: 'Equal intervals of inhale, hold, exhale, and hold for deep centering.',
    inhaleSeconds: 4,
    holdAfterInhaleSeconds: 4,
    exhaleSeconds: 4,
    holdAfterExhaleSeconds: 4,
    totalCycles: 5,
  );

  static const BreathingPattern relaxingBreath = BreathingPattern(
    id: 'relaxing_breath',
    name: '4-7-8 Relaxing Breath',
    description: 'An extended exhale to soothe the nervous system before rest.',
    inhaleSeconds: 4,
    holdAfterInhaleSeconds: 7,
    exhaleSeconds: 8,
    holdAfterExhaleSeconds: 0,
    totalCycles: 4,
  );

  static const BreathingPattern simpleSlow = BreathingPattern(
    id: 'simple_slow',
    name: 'Simple Slow Breath',
    description: 'Gentle, balanced rhythm for a fast 1-minute reset.',
    inhaleSeconds: 5,
    holdAfterInhaleSeconds: 0,
    exhaleSeconds: 5,
    holdAfterExhaleSeconds: 0,
    totalCycles: 6,
  );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        inhaleSeconds,
        holdAfterInhaleSeconds,
        exhaleSeconds,
        holdAfterExhaleSeconds,
        totalCycles,
      ];
}
