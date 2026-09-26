import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../data/models/session_model.dart';
import '../../../data/repositories/session_repository.dart';
import '../domain/explore_filter.dart';

class ExploreViewState extends Equatable {
  const ExploreViewState({
    this.isLoading = false,
    this.allSessions = const [],
    this.filteredSessions = const [],
    this.favoriteSessionIds = const {},
    this.filter = const ExploreFilter(),
    this.errorMessage,
  });

  final bool isLoading;
  final List<Session> allSessions;
  final List<Session> filteredSessions;
  final Set<String> favoriteSessionIds;
  final ExploreFilter filter;
  final String? errorMessage;

  bool isFavorite(String sessionId) => favoriteSessionIds.contains(sessionId);

  ExploreViewState copyWith({
    bool? isLoading,
    List<Session>? allSessions,
    List<Session>? filteredSessions,
    Set<String>? favoriteSessionIds,
    ExploreFilter? filter,
    String? errorMessage,
  }) {
    return ExploreViewState(
      isLoading: isLoading ?? this.isLoading,
      allSessions: allSessions ?? this.allSessions,
      filteredSessions: filteredSessions ?? this.filteredSessions,
      favoriteSessionIds: favoriteSessionIds ?? this.favoriteSessionIds,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        allSessions,
        filteredSessions,
        favoriteSessionIds,
        filter,
        errorMessage,
      ];
}

class ExploreNotifier extends StateNotifier<ExploreViewState> {
  ExploreNotifier(this._repository) : super(const ExploreViewState()) {
    load();
  }

  final SessionRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final sessions = await _repository.getAllSessions();
      final favIds = await _repository.getFavoriteIds();
      final filtered = _applyFilter(sessions, favIds, state.filter);

      state = state.copyWith(
        isLoading: false,
        allSessions: sessions,
        filteredSessions: filtered,
        favoriteSessionIds: favIds,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load practices. Please try again.',
      );
    }
  }

  void setSearchQuery(String query) {
    final updatedFilter = state.filter.copyWith(searchQuery: query);
    _updateFilter(updatedFilter);
  }

  void setCategory(SessionCategory? category) {
    final updatedFilter = state.filter.copyWith(
      category: () => category,
    );
    _updateFilter(updatedFilter);
  }

  void setDuration(ExploreDurationFilter duration) {
    final updatedFilter = state.filter.copyWith(duration: duration);
    _updateFilter(updatedFilter);
  }

  void setDifficulty(SessionDifficulty? difficulty) {
    final updatedFilter = state.filter.copyWith(
      difficulty: () => difficulty,
    );
    _updateFilter(updatedFilter);
  }

  void toggleOnlyFavorites() {
    final updatedFilter = state.filter.copyWith(
      onlyFavorites: !state.filter.onlyFavorites,
    );
    _updateFilter(updatedFilter);
  }

  void setOnlyFavorites(bool onlyFavorites) {
    final updatedFilter = state.filter.copyWith(onlyFavorites: onlyFavorites);
    _updateFilter(updatedFilter);
  }

  void applyFilter(ExploreFilter filter) {
    _updateFilter(filter);
  }

  void clearFilters() {
    _updateFilter(const ExploreFilter());
  }

  Future<void> toggleFavorite(String sessionId) async {
    // 1. Optimistic update in state
    final updatedFavs = Set<String>.from(state.favoriteSessionIds);
    final isFav = updatedFavs.contains(sessionId);
    if (isFav) {
      updatedFavs.remove(sessionId);
    } else {
      updatedFavs.add(sessionId);
    }

    // 2. Re-filter with the new favorite set
    final updatedFiltered = _applyFilter(
      state.allSessions,
      updatedFavs,
      state.filter,
    );

    state = state.copyWith(
      favoriteSessionIds: updatedFavs,
      filteredSessions: updatedFiltered,
    );

    // 3. Persist locally to repository
    try {
      await _repository.toggleFavorite(sessionId);
    } catch (_) {
      // Revert if failed
      await load();
    }
  }

  void _updateFilter(ExploreFilter newFilter) {
    final filtered = _applyFilter(
      state.allSessions,
      state.favoriteSessionIds,
      newFilter,
    );

    state = state.copyWith(
      filter: newFilter,
      filteredSessions: filtered,
    );
  }

  List<Session> _applyFilter(
    List<Session> sessions,
    Set<String> favIds,
    ExploreFilter filter,
  ) {
    return sessions.where((s) {
      final isFav = favIds.contains(s.id);
      return filter.matches(s, isFavorite: isFav);
    }).toList();
  }
}

final exploreNotifierProvider =
    StateNotifierProvider<ExploreNotifier, ExploreViewState>((ref) {
  final repo = ref.watch(sessionRepositoryProvider);
  return ExploreNotifier(repo);
});
