import 'package:equatable/equatable.dart';
import '../../../data/models/session_model.dart';

enum ExploreDurationFilter {
  all('All Durations'),
  short('1–3 min'),
  medium('5 min'),
  long('10+ min');

  const ExploreDurationFilter(this.label);
  final String label;

  bool matches(int durationSeconds) {
    switch (this) {
      case ExploreDurationFilter.all:
        return true;
      case ExploreDurationFilter.short:
        return durationSeconds <= 180;
      case ExploreDurationFilter.medium:
        return durationSeconds > 180 && durationSeconds <= 300;
      case ExploreDurationFilter.long:
        return durationSeconds > 300;
    }
  }
}

class ExploreFilter extends Equatable {
  const ExploreFilter({
    this.searchQuery = '',
    this.category,
    this.duration = ExploreDurationFilter.all,
    this.difficulty,
    this.onlyFavorites = false,
  });

  final String searchQuery;
  final SessionCategory? category;
  final ExploreDurationFilter duration;
  final SessionDifficulty? difficulty;
  final bool onlyFavorites;

  bool get hasActiveFilters =>
      searchQuery.trim().isNotEmpty ||
      category != null ||
      duration != ExploreDurationFilter.all ||
      difficulty != null ||
      onlyFavorites;

  int get activeFiltersCount {
    int count = 0;
    if (category != null) count++;
    if (duration != ExploreDurationFilter.all) count++;
    if (difficulty != null) count++;
    if (onlyFavorites) count++;
    return count;
  }

  ExploreFilter copyWith({
    String? searchQuery,
    SessionCategory? Function()? category,
    ExploreDurationFilter? duration,
    SessionDifficulty? Function()? difficulty,
    bool? onlyFavorites,
  }) {
    return ExploreFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category != null ? category() : this.category,
      duration: duration ?? this.duration,
      difficulty: difficulty != null ? difficulty() : this.difficulty,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }

  ExploreFilter clear() => const ExploreFilter();

  bool matches(Session session, {required bool isFavorite}) {
    // 1. Search Query filter (title, description, tags, category)
    final cleanQuery = searchQuery.trim().toLowerCase();
    if (cleanQuery.isNotEmpty) {
      final inTitle = session.title.toLowerCase().contains(cleanQuery);
      final inDesc = session.description.toLowerCase().contains(cleanQuery);
      final inCategory = session.category.displayName.toLowerCase().contains(cleanQuery) ||
          session.category.name.toLowerCase().contains(cleanQuery);
      final inTags = session.tags.any((tag) => tag.toLowerCase().contains(cleanQuery));

      if (!inTitle && !inDesc && !inCategory && !inTags) {
        return false;
      }
    }

    // 2. Category filter
    if (category != null && session.category != category) {
      return false;
    }

    // 3. Duration filter
    if (!duration.matches(session.durationSeconds)) {
      return false;
    }

    // 4. Difficulty filter
    if (difficulty != null && session.difficulty != difficulty) {
      return false;
    }

    // 5. Favorites filter
    if (onlyFavorites && !isFavorite) {
      return false;
    }

    return true;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        category,
        duration,
        difficulty,
        onlyFavorites,
      ];
}
