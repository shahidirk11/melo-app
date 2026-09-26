import 'package:equatable/equatable.dart';

enum SessionType {
  guidedMeditation('Guided Meditation'),
  breathing('Breathing Exercise'),
  focus('Mindful Focus'),
  bodyScan('Body Scan'),
  sleep('Sleep & Wind Down'),
  ambient('Ambient Sound'),
  textGuided('Text-Guided Reset');

  const SessionType(this.displayName);
  final String displayName;
}

enum SessionCategory {
  calm('Calm'),
  focus('Focus'),
  sleep('Sleep'),
  morning('Morning'),
  breathing('Breathing'),
  beginner('Beginner'),
  stressReset('Stress Reset'),
  relaxation('Relaxation');

  const SessionCategory(this.displayName);
  final String displayName;
}

enum SessionDifficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  allLevels('All Levels');

  const SessionDifficulty(this.displayName);
  final String displayName;
}

/// A single step in a text-guided or narrated session script.
class GuidanceStep extends Equatable {
  const GuidanceStep({
    required this.startSecond,
    required this.durationSeconds,
    required this.instruction,
    this.subtext,
  });

  final int startSecond;
  final int durationSeconds;
  final String instruction;
  final String? subtext;

  @override
  List<Object?> get props => [startSecond, durationSeconds, instruction, subtext];
}

class Session extends Equatable {
  const Session({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.durationSeconds,
    required this.difficulty,
    this.tags = const [],
    this.guidanceSteps = const [],
    this.audioAsset,
    this.backgroundSoundAsset,
    this.isPremium = false,
    this.isFavorite = false,
    this.sortOrder = 0,
  });

  final String id;
  final String title;
  final String description;
  final SessionCategory category;
  final SessionType type;
  final int durationSeconds;
  final SessionDifficulty difficulty;
  final List<String> tags;
  final List<GuidanceStep> guidanceSteps;
  final String? audioAsset;
  final String? backgroundSoundAsset;
  final bool isPremium;
  final bool isFavorite;
  final int sortOrder;

  int get durationMinutes => (durationSeconds / 60).round();

  Session copyWith({
    String? id,
    String? title,
    String? description,
    SessionCategory? category,
    SessionType? type,
    int? durationSeconds,
    SessionDifficulty? difficulty,
    List<String>? tags,
    List<GuidanceStep>? guidanceSteps,
    String? audioAsset,
    String? backgroundSoundAsset,
    bool? isPremium,
    bool? isFavorite,
    int? sortOrder,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      guidanceSteps: guidanceSteps ?? this.guidanceSteps,
      audioAsset: audioAsset ?? this.audioAsset,
      backgroundSoundAsset: backgroundSoundAsset ?? this.backgroundSoundAsset,
      isPremium: isPremium ?? this.isPremium,
      isFavorite: isFavorite ?? this.isFavorite,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        type,
        durationSeconds,
        difficulty,
        tags,
        guidanceSteps,
        audioAsset,
        backgroundSoundAsset,
        isPremium,
        isFavorite,
        sortOrder,
      ];
}
