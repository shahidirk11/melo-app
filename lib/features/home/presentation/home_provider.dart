import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../data/models/mood_entry_model.dart';
import '../../../data/models/session_model.dart';
import '../domain/recommendation_engine.dart';

class HomeViewState {
  const HomeViewState({
    required this.greeting,
    this.selectedMood,
    required this.primarySession,
    required this.recommendationReason,
    required this.quickResets,
    this.secondarySuggestion,
    required this.todayMinutes,
    required this.todaySessionsCount,
    this.upcomingReminder,
  });

  final String greeting;
  final MoodType? selectedMood;
  final Session primarySession;
  final String recommendationReason;
  final List<Session> quickResets;
  final Session? secondarySuggestion;
  final int todayMinutes;
  final int todaySessionsCount;
  final String? upcomingReminder;
}

final recommendationEngineProvider = Provider<RecommendationEngine>((ref) {
  return const RecommendationEngine();
});

final homeViewStateProvider = FutureProvider<HomeViewState>((ref) async {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final moodRepo = ref.watch(moodRepositoryProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  final reminderRepo = ref.watch(reminderRepositoryProvider);
  final prefs = ref.watch(userPreferencesProvider);
  final engine = ref.watch(recommendationEngineProvider);

  final now = DateTime.now();

  // 1. Fetch data asynchronously
  final allSessions = await sessionRepo.getAllSessions();
  final latestMood = await moodRepo.getLatestMood();
  final history = await progressRepo.getHistory(limit: 40);
  final reminders = await reminderRepo.getReminders();

  // 2. Greeting calculation
  final hour = now.hour;
  final timeGreeting = hour < 12
      ? 'Good morning'
      : (hour < 17
          ? 'Good afternoon'
          : (hour < 21 ? 'Good evening' : 'Quiet night'));
  final greetingEmoji = hour < 12
      ? '🌤️'
      : (hour < 17 ? '☀️' : (hour < 21 ? '🌙' : '🌌'));
  final firstName = prefs.firstName.trim();
  final greeting = firstName.isNotEmpty
      ? '$timeGreeting, $firstName $greetingEmoji'
      : '$timeGreeting $greetingEmoji';

  // 3. Today's practice calculations
  final todayCompleted = history.where((r) {
    final local = r.completedAt.toLocal();
    return r.wasCompleted &&
        local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }).toList();

  final todaySeconds = todayCompleted.fold<int>(
    0,
    (sum, r) => sum + r.durationCompletedSeconds,
  );
  final todayMinutes = (todaySeconds / 60).round();
  final todayCount = todayCompleted.length;

  // 4. Upcoming reminder preview
  String? reminderPreview;
  if (prefs.notificationsEnabled) {
    final activeReminders = reminders.where((r) => r.isEnabled).toList();
    if (activeReminders.isNotEmpty) {
      // Find closest upcoming reminder
      final first = activeReminders.first;
      reminderPreview = '${first.slot.title} · ${first.formattedTime}';
    }
  }

  // 5. Run deterministic recommendation engine
  final recommendation = engine.recommend(
    allSessions: allSessions,
    preferences: prefs,
    history: history,
    currentMood: latestMood?.mood,
    currentTime: now,
  );

  return HomeViewState(
    greeting: greeting,
    selectedMood: latestMood?.mood,
    primarySession: recommendation.primarySession,
    recommendationReason: recommendation.recommendationReason,
    quickResets: recommendation.quickResets,
    secondarySuggestion: recommendation.secondarySuggestion,
    todayMinutes: todayMinutes,
    todaySessionsCount: todayCount,
    upcomingReminder: reminderPreview,
  );
});
