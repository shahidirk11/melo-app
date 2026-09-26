import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/data/datasources/local_content_seed.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/repositories/session_repository.dart';

void main() {
  group('Seed Content and Session Repository Tests', () {
    test('LocalContentSeed contains required durations and categories', () {
      final sessions = LocalContentSeed.sessions;
      expect(sessions.isNotEmpty, true);

      // Verify presence of 1m, 3m, 5m, 10m, and sleep sessions
      expect(sessions.any((s) => s.durationSeconds == 60), true);
      expect(sessions.any((s) => s.durationSeconds == 180), true);
      expect(sessions.any((s) => s.durationSeconds == 300), true);
      expect(sessions.any((s) => s.durationSeconds == 600), true);
      expect(sessions.any((s) => s.category == SessionCategory.sleep), true);
    });

    test('InMemorySessionRepository searches by title and tag accurately', () async {
      final repo = InMemorySessionRepository();

      final sleepResults = await repo.searchSessions('sleep');
      expect(sleepResults.isNotEmpty, true);
      expect(sleepResults.every((s) =>
          s.title.toLowerCase().contains('sleep') ||
          s.description.toLowerCase().contains('sleep') ||
          s.tags.contains('sleep')), true);

      final breathResults = await repo.getSessionsByCategory(SessionCategory.breathing);
      expect(breathResults.isNotEmpty, true);
      expect(breathResults.every((s) => s.category == SessionCategory.breathing), true);
    });

    test('InMemorySessionRepository toggles favorites correctly', () async {
      final repo = InMemorySessionRepository();
      const testId = 'session_1m_reset';

      var session = await repo.getSessionById(testId);
      expect(session?.isFavorite, false);

      await repo.toggleFavorite(testId);
      session = await repo.getSessionById(testId);
      expect(session?.isFavorite, true);

      final favorites = await repo.getFavoriteSessions();
      expect(favorites.length, 1);
      expect(favorites.first.id, testId);

      await repo.toggleFavorite(testId);
      session = await repo.getSessionById(testId);
      expect(session?.isFavorite, false);
    });
  });
}
