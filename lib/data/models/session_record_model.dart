import 'package:equatable/equatable.dart';
import 'mood_entry_model.dart';
import 'session_model.dart';

class SessionRecord extends Equatable {
  const SessionRecord({
    required this.id,
    required this.sessionId,
    required this.sessionTitle,
    required this.sessionType,
    required this.startedAt,
    required this.completedAt,
    required this.durationCompletedSeconds,
    required this.wasCompleted,
    this.moodBefore,
    this.moodAfter,
  });

  final String id;
  final String sessionId;
  final String sessionTitle;
  final SessionType sessionType;
  final DateTime startedAt;
  final DateTime completedAt;
  final int durationCompletedSeconds;
  final bool wasCompleted;
  final MoodType? moodBefore;
  final ReflectionMood? moodAfter;

  int get durationCompletedMinutes => (durationCompletedSeconds / 60).round();

  @override
  List<Object?> get props => [
        id,
        sessionId,
        sessionTitle,
        sessionType,
        startedAt,
        completedAt,
        durationCompletedSeconds,
        wasCompleted,
        moodBefore,
        moodAfter,
      ];
}
