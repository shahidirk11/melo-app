import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/features/explore/domain/explore_filter.dart';
import 'package:melo_app/features/explore/presentation/explore_provider.dart';

void main() {
  group('ExploreFilter Domain Tests', () {
    const testSession = Session(
      id: 'test_session_1',
      title: 'Mindful Morning Breathing',
      description: 'Awaken your body with gentle conscious breaths and calm presence.',
      category: SessionCategory.morning,
      type: SessionType.breathing,
      durationSeconds: 180,
      difficulty: SessionDifficulty.beginner,
      tags: ['sunrise', 'gentle', 'awakening'],
    );

    test('Search query matches title', () {
      const filter = ExploreFilter(searchQuery: 'morning');
      expect(filter.matches(testSession, isFavorite: false), isTrue);
    });

    test('Search query matches description', () {
      const filter = ExploreFilter(searchQuery: 'conscious breaths');
      expect(filter.matches(testSession, isFavorite: false), isTrue);
    });

    test('Search query matches tags', () {
      const filter = ExploreFilter(searchQuery: 'sunrise');
      expect(filter.matches(testSession, isFavorite: false), isTrue);
    });

    test('Search query matches category', () {
      const filter = ExploreFilter(searchQuery: 'Morning');
      expect(filter.matches(testSession, isFavorite: false), isTrue);
    });

    test('Search query rejects non-matching session', () {
      const filter = ExploreFilter(searchQuery: 'sleep insomnia');
      expect(filter.matches(testSession, isFavorite: false), isFalse);
    });

    test('Category filter matches exact category and rejects other categories', () {
      const matchingFilter = ExploreFilter(category: SessionCategory.morning);
      expect(matchingFilter.matches(testSession, isFavorite: false), isTrue);

      const nonMatchingFilter = ExploreFilter(category: SessionCategory.sleep);
      expect(nonMatchingFilter.matches(testSession, isFavorite: false), isFalse);
    });

    test('Duration filter matches short (1-3 min) correctly', () {
      const shortFilter = ExploreFilter(duration: ExploreDurationFilter.short);
      expect(shortFilter.matches(testSession, isFavorite: false), isTrue);

      const mediumFilter = ExploreFilter(duration: ExploreDurationFilter.medium);
      expect(mediumFilter.matches(testSession, isFavorite: false), isFalse);

      const longFilter = ExploreFilter(duration: ExploreDurationFilter.long);
      expect(longFilter.matches(testSession, isFavorite: false), isFalse);
    });

    test('Difficulty filter matches Beginner and rejects Intermediate', () {
      const beginnerFilter = ExploreFilter(difficulty: SessionDifficulty.beginner);
      expect(beginnerFilter.matches(testSession, isFavorite: false), isTrue);

      const intermediateFilter = ExploreFilter(difficulty: SessionDifficulty.intermediate);
      expect(intermediateFilter.matches(testSession, isFavorite: false), isFalse);
    });

    test('Favorites filter checks favorite state correctly', () {
      const favFilter = ExploreFilter(onlyFavorites: true);
      expect(favFilter.matches(testSession, isFavorite: true), isTrue);
      expect(favFilter.matches(testSession, isFavorite: false), isFalse);
    });

    test('Active filters count and hasActiveFilters', () {
      const defaultFilter = ExploreFilter();
      expect(defaultFilter.hasActiveFilters, isFalse);
      expect(defaultFilter.activeFiltersCount, 0);

      final activeFilter = defaultFilter.copyWith(
        category: () => SessionCategory.calm,
        duration: ExploreDurationFilter.short,
        onlyFavorites: true,
      );
      expect(activeFilter.hasActiveFilters, isTrue);
      expect(activeFilter.activeFiltersCount, 3);
    });
  });

  group('ExploreNotifier State & Logic Tests', () {
    late InMemorySessionRepository sessionRepo;
    late ExploreNotifier notifier;

    setUp(() async {
      sessionRepo = InMemorySessionRepository();
      notifier = ExploreNotifier(sessionRepo);
      // Wait for initial load
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });

    test('Loads all seed sessions on initial load', () {
      final state = notifier.state;
      expect(state.isLoading, isFalse);
      expect(state.allSessions.length, greaterThanOrEqualTo(10));
      expect(state.filteredSessions.length, state.allSessions.length);
    });

    test('Filters by Category dynamically', () {
      notifier.setCategory(SessionCategory.sleep);
      final state = notifier.state;
      expect(state.filter.category, SessionCategory.sleep);
      expect(state.filteredSessions.isNotEmpty, isTrue);
      for (final s in state.filteredSessions) {
        expect(s.category, SessionCategory.sleep);
      }
    });

    test('Filters by Search query locally across title, desc, tags', () {
      notifier.setSearchQuery('Box');
      final state = notifier.state;
      expect(state.filteredSessions.isNotEmpty, isTrue);
      for (final s in state.filteredSessions) {
        final matches = s.title.toLowerCase().contains('box') ||
            s.description.toLowerCase().contains('box') ||
            s.tags.any((t) => t.toLowerCase().contains('box'));
        expect(matches, isTrue);
      }
    });

    test('Filters by Duration (1-3m, 5m, 10+m)', () {
      notifier.setDuration(ExploreDurationFilter.short);
      final state = notifier.state;
      expect(state.filteredSessions.isNotEmpty, isTrue);
      for (final s in state.filteredSessions) {
        expect(s.durationSeconds, lessThanOrEqualTo(180));
      }
    });

    test('Toggles favorites and persists locally in repository', () async {
      final targetSessionId = notifier.state.allSessions.first.id;
      expect(notifier.state.isFavorite(targetSessionId), isFalse);

      // 1. Favorite session
      await notifier.toggleFavorite(targetSessionId);
      expect(notifier.state.isFavorite(targetSessionId), isTrue);

      final repoCheck1 = await sessionRepo.isFavorite(targetSessionId);
      expect(repoCheck1, isTrue);

      // 2. Filter by favorites only
      notifier.toggleOnlyFavorites();
      expect(notifier.state.filter.onlyFavorites, isTrue);
      expect(notifier.state.filteredSessions.length, 1);
      expect(notifier.state.filteredSessions.first.id, targetSessionId);

      // 3. Unfavorite session while filtering favorites
      await notifier.toggleFavorite(targetSessionId);
      expect(notifier.state.isFavorite(targetSessionId), isFalse);
      expect(notifier.state.filteredSessions.isEmpty, isTrue);

      final repoCheck2 = await sessionRepo.isFavorite(targetSessionId);
      expect(repoCheck2, isFalse);
    });

    test('Clears all active filters back to initial full list', () {
      notifier.setCategory(SessionCategory.calm);
      notifier.setSearchQuery('breathe');
      notifier.setDuration(ExploreDurationFilter.short);
      expect(notifier.state.filter.hasActiveFilters, isTrue);

      notifier.clearFilters();
      expect(notifier.state.filter.hasActiveFilters, isFalse);
      expect(notifier.state.filteredSessions.length, notifier.state.allSessions.length);
    });
  });
}
