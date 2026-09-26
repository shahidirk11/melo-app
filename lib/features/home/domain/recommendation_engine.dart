import '../../../data/models/mood_entry_model.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/session_record_model.dart';
import '../../../data/models/user_preferences_model.dart';

class RecommendationResult {
  const RecommendationResult({
    required this.primarySession,
    required this.recommendationReason,
    required this.quickResets,
    this.secondarySuggestion,
  });

  final Session primarySession;
  final String recommendationReason;
  final List<Session> quickResets;
  final Session? secondarySuggestion;
}

class RecommendationEngine {
  const RecommendationEngine();

  RecommendationResult recommend({
    required List<Session> allSessions,
    required UserPreferences preferences,
    required List<SessionRecord> history,
    MoodType? currentMood,
    DateTime? currentTime,
  }) {
    if (allSessions.isEmpty) {
      throw StateError('Cannot recommend from an empty session list.');
    }

    final now = currentTime ?? DateTime.now();
    final hour = now.hour;

    // Determine time of day bucket
    final bool isMorning = hour >= 5 && hour < 12;
    final bool isAfternoon = hour >= 12 && hour < 17;
    final bool isEvening = hour >= 17 && hour < 21;
    final bool isNight = hour >= 21 || hour < 5;

    // Set of recently completed session IDs (within last 24h)
    final recentCutoff = now.subtract(const Duration(hours: 24));
    final recentlyCompletedIds = history
        .where((r) => r.wasCompleted && r.completedAt.isAfter(recentCutoff))
        .map((r) => r.sessionId)
        .toSet();

    // Score all sessions deterministically
    final scoredSessions = allSessions.map((session) {
      double score = 100.0;

      // 1. Mood relevance (Highest priority)
      if (currentMood != null) {
        score += _scoreForMood(session, currentMood);
      }

      // 2. Time-of-day relevance
      if (isMorning) {
        if (session.category == SessionCategory.morning) score += 45;
        if (session.category == SessionCategory.breathing) score += 25;
        if (session.category == SessionCategory.calm) score += 20;
      } else if (isAfternoon) {
        if (session.category == SessionCategory.focus) score += 40;
        if (session.category == SessionCategory.stressReset) score += 35;
        if (session.category == SessionCategory.relaxation) score += 30;
      } else if (isEvening) {
        if (session.category == SessionCategory.calm) score += 40;
        if (session.category == SessionCategory.relaxation) score += 40;
        if (session.category == SessionCategory.sleep) score += 35;
      } else if (isNight) {
        if (session.category == SessionCategory.sleep) score += 60;
        if (session.category == SessionCategory.breathing) score += 30;
        if (session.category == SessionCategory.relaxation) score += 25;
      }

      // 3. User Goals alignment
      for (final goal in preferences.goals) {
        final g = goal.toLowerCase();
        if (g.contains('stress') && session.category == SessionCategory.stressReset) {
          score += 25;
        } else if (g.contains('focus') && session.category == SessionCategory.focus) {
          score += 25;
        } else if (g.contains('sleep') && session.category == SessionCategory.sleep) {
          score += 25;
        } else if (g.contains('calm') && session.category == SessionCategory.calm) {
          score += 20;
        } else if (g.contains('habit') && session.difficulty == SessionDifficulty.beginner) {
          score += 15;
        }
      }

      // 4. Preferred duration proximity
      final prefDuration = preferences.preferredDurationSeconds;
      final diffSeconds = (session.durationSeconds - prefDuration).abs();
      if (diffSeconds == 0) {
        score += 30;
      } else if (diffSeconds <= 120) {
        score += 20;
      } else if (diffSeconds <= 300) {
        score += 10;
      }

      // 5. Bookmark bonus
      if (session.isFavorite) {
        score += 12;
      }

      // 6. Recency penalty (avoids recommending the same recently completed session)
      if (recentlyCompletedIds.contains(session.id)) {
        score -= 90;
      }

      return (session: session, score: score);
    }).toList();

    // Sort descending by score
    scoredSessions.sort((a, b) => b.score.compareTo(a.score));

    final primarySession = scoredSessions.first.session;

    // Reason generation
    final reason = _generateRecommendationReason(
      primarySession: primarySession,
      currentMood: currentMood,
      isMorning: isMorning,
      isAfternoon: isAfternoon,
      isEvening: isEvening,
      isNight: isNight,
    );

    // Quick resets (sessions <= 180s, distinct from primary)
    final quickResets = allSessions
        .where((s) => s.durationSeconds <= 180 && s.id != primarySession.id)
        .take(3)
        .toList();

    // Secondary suggestion (distinct category from primary, e.g. Sleep or Breathing)
    Session? secondary;
    for (final entry in scoredSessions.skip(1)) {
      if (entry.session.category != primarySession.category &&
          entry.session.durationSeconds > 180 &&
          entry.session.id != primarySession.id) {
        secondary = entry.session;
        break;
      }
    }

    return RecommendationResult(
      primarySession: primarySession,
      recommendationReason: reason,
      quickResets: quickResets,
      secondarySuggestion: secondary,
    );
  }

  double _scoreForMood(Session session, MoodType mood) {
    return switch (mood) {
      MoodType.stressed => switch (session.category) {
          SessionCategory.stressReset => 55.0,
          SessionCategory.calm => 45.0,
          SessionCategory.breathing => 40.0,
          _ => 0.0,
        },
      MoodType.tired => switch (session.category) {
          SessionCategory.sleep => 55.0,
          SessionCategory.relaxation => 45.0,
          SessionCategory.breathing => 30.0,
          _ => 0.0,
        },
      MoodType.okay => switch (session.category) {
          SessionCategory.calm => 35.0,
          SessionCategory.breathing => 30.0,
          SessionCategory.relaxation => 25.0,
          _ => 10.0,
        },
      MoodType.good => switch (session.category) {
          SessionCategory.focus => 35.0,
          SessionCategory.morning => 30.0,
          SessionCategory.relaxation => 25.0,
          _ => 15.0,
        },
      MoodType.calm => switch (session.category) {
          SessionCategory.focus => 35.0,
          SessionCategory.relaxation => 30.0,
          SessionCategory.beginner => 20.0,
          _ => 15.0,
        },
    };
  }

  String _generateRecommendationReason({
    required Session primarySession,
    required MoodType? currentMood,
    required bool isMorning,
    required bool isAfternoon,
    required bool isEvening,
    required bool isNight,
  }) {
    if (currentMood == MoodType.stressed) {
      return 'Gentle guidance to let tension soften and clear your mind.';
    }
    if (currentMood == MoodType.tired) {
      return 'Unwind with restorative stillness and soothing breath.';
    }
    if (currentMood == MoodType.calm) {
      return 'Deepen your steady presence with a focused pause.';
    }
    if (isMorning) {
      return 'Start your morning with grounded intention and calm energy.';
    }
    if (isAfternoon) {
      return 'A mid-day refresher to reboot your attention and breathe.';
    }
    if (isEvening) {
      return 'Slow down from the day’s activities and settle in for the evening.';
    }
    if (isNight) {
      return 'Drift softly into restorative rest with tranquil pacing.';
    }
    return 'Your personalized moment of daily calm.';
  }
}
