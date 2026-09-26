import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/local_content_seed.dart';
import '../models/session_model.dart';

abstract class SessionRepository {
  Future<List<Session>> getAllSessions();
  Future<Session?> getSessionById(String id);
  Future<List<Session>> getSessionsByCategory(SessionCategory category);
  Future<List<Session>> searchSessions(String query);
  Future<List<Session>> getFavoriteSessions();
  Future<Set<String>> getFavoriteIds();
  Future<bool> isFavorite(String sessionId);
  Future<void> toggleFavorite(String sessionId);
  Future<void> setFavorite(String sessionId, bool isFavorite);
  Future<void> addSession(Session session);
  Future<void> updateSession(Session session);
  Future<void> deleteSession(String id);
  Future<void> resetToSeedContent();
}

class InMemorySessionRepository implements SessionRepository {
  InMemorySessionRepository({
    List<Session>? initialSessions,
    Set<String>? initialFavoriteIds,
    SharedPreferences? sharedPreferences,
  })  : _sessions = List.of(initialSessions ?? LocalContentSeed.sessions),
        _favoriteIds = Set.of(initialFavoriteIds ?? {}),
        _prefs = sharedPreferences {
    _initPersistence();
  }

  static const String _favoritesPrefKey = 'melo_saved_favorite_session_ids';
  final List<Session> _sessions;
  final Set<String> _favoriteIds;
  SharedPreferences? _prefs;

  Future<void> _initPersistence() async {
    if (_prefs == null) {
      try {
        _prefs = await SharedPreferences.getInstance();
      } catch (_) {
        // Fallback for tests or before platform channel is bound
      }
    }
    if (_prefs != null) {
      final saved = _prefs?.getStringList(_favoritesPrefKey);
      if (saved != null) {
        _favoriteIds.addAll(saved);
      }
    }
  }

  Future<void> _persistFavorites() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }
      await _prefs?.setStringList(_favoritesPrefKey, _favoriteIds.toList());
    } catch (_) {
      // In-memory fallback
    }
  }

  @override
  Future<Set<String>> getFavoriteIds() async {
    return Set.unmodifiable(_favoriteIds);
  }

  @override
  Future<List<Session>> getAllSessions() async {
    return _sessions.map((s) {
      return s.copyWith(isFavorite: _favoriteIds.contains(s.id));
    }).toList();
  }

  @override
  Future<Session?> getSessionById(String id) async {
    try {
      final session = _sessions.firstWhere((s) => s.id == id);
      return session.copyWith(isFavorite: _favoriteIds.contains(session.id));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Session>> getSessionsByCategory(SessionCategory category) async {
    return _sessions
        .where((s) => s.category == category)
        .map((s) => s.copyWith(isFavorite: _favoriteIds.contains(s.id)))
        .toList();
  }

  @override
  Future<List<Session>> searchSessions(String query) async {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return getAllSessions();

    return _sessions.where((s) {
      final inTitle = s.title.toLowerCase().contains(clean);
      final inDesc = s.description.toLowerCase().contains(clean);
      final inCategory = s.category.displayName.toLowerCase().contains(clean) ||
          s.category.name.toLowerCase().contains(clean);
      final inTags = s.tags.any((t) => t.toLowerCase().contains(clean));
      return inTitle || inDesc || inCategory || inTags;
    }).map((s) => s.copyWith(isFavorite: _favoriteIds.contains(s.id))).toList();
  }

  @override
  Future<List<Session>> getFavoriteSessions() async {
    return _sessions
        .where((s) => _favoriteIds.contains(s.id))
        .map((s) => s.copyWith(isFavorite: true))
        .toList();
  }

  @override
  Future<bool> isFavorite(String sessionId) async {
    return _favoriteIds.contains(sessionId);
  }

  @override
  Future<void> toggleFavorite(String sessionId) async {
    if (_favoriteIds.contains(sessionId)) {
      _favoriteIds.remove(sessionId);
    } else {
      _favoriteIds.add(sessionId);
    }
    await _persistFavorites();
  }

  @override
  Future<void> setFavorite(String sessionId, bool isFavorite) async {
    if (isFavorite) {
      _favoriteIds.add(sessionId);
    } else {
      _favoriteIds.remove(sessionId);
    }
    await _persistFavorites();
  }

  @override
  Future<void> addSession(Session session) async {
    _sessions.removeWhere((s) => s.id == session.id);
    _sessions.add(session);
  }

  @override
  Future<void> updateSession(Session session) async {
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      _sessions[index] = session;
    } else {
      _sessions.add(session);
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    _sessions.removeWhere((s) => s.id == id);
    _favoriteIds.remove(id);
    await _persistFavorites();
  }

  @override
  Future<void> resetToSeedContent() async {
    _sessions.clear();
    _sessions.addAll(LocalContentSeed.sessions);
  }
}
