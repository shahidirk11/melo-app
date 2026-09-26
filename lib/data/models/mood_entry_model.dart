import 'package:equatable/equatable.dart';

enum MoodType {
  calm('Calm', '😌'),
  good('Good', '🙂'),
  okay('Okay', '😐'),
  stressed('Stressed', '😟'),
  tired('Tired', '😴');

  const MoodType(this.label, this.emoji);
  final String label;
  final String emoji;
}

enum ReflectionMood {
  better('Better', '🙂'),
  same('About the same', '😐'),
  moreRelaxed('More relaxed', '😌'),
  stillUnsettled('Still unsettled', '😕');

  const ReflectionMood(this.label, this.emoji);
  final String label;
  final String emoji;
}

class MoodEntry extends Equatable {
  const MoodEntry({
    required this.id,
    required this.timestamp,
    required this.mood,
    this.note,
  });

  final String id;
  final DateTime timestamp;
  final MoodType mood;
  final String? note;

  @override
  List<Object?> get props => [id, timestamp, mood, note];
}
