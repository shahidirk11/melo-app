import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/app/theme/app_theme.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/models/session_record_model.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/features/progress/presentation/progress_screen.dart';
import 'package:melo_app/features/progress/presentation/widgets/gentle_streak_banner.dart';
import 'package:melo_app/features/progress/presentation/widgets/monthly_summary_card.dart';
import 'package:melo_app/features/progress/presentation/widgets/practice_metrics_grid.dart';
import 'package:melo_app/features/progress/presentation/widgets/session_record_card.dart';
import 'package:melo_app/features/progress/presentation/widgets/session_record_details_modal.dart';
import 'package:melo_app/features/progress/presentation/widgets/weekly_activity_chart.dart';

void main() {
  group('ProgressScreen Widget Tests', () {
    late InMemoryProgressRepository progressRepo;

    setUp(() {
      progressRepo = InMemoryProgressRepository();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          progressRepositoryProvider.overrideWithValue(progressRepo),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProgressScreen(),
        ),
      );
    }

    testWidgets('1. Empty progress state: renders zero metrics, ready streak, and empty history', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify header
      expect(find.text('Your Journey'), findsOneWidget);
      expect(find.text('Small mindful pauses add up to lasting peace.'), findsOneWidget);

      // Verify Gentle Streak Banner
      expect(find.byType(GentleStreakBanner), findsOneWidget);
      expect(find.text('Ready for today 🌱'), findsOneWidget);

      // Verify Metrics Grid
      expect(find.byType(PracticeMetricsGrid), findsOneWidget);
      expect(find.text('Total minutes'), findsOneWidget);
      expect(find.text('Resets completed'), findsOneWidget);
      expect(find.text('Active days'), findsOneWidget);
      expect(find.text("Today's minutes"), findsOneWidget);

      // Verify Weekly Chart
      expect(find.byType(WeeklyActivityChart), findsOneWidget);
      expect(find.textContaining('A gentle week so far'), findsOneWidget);

      // Verify Monthly Summary
      expect(find.byType(MonthlySummaryCard), findsOneWidget);

      // Verify empty history view
      expect(find.text('No practice history yet'), findsOneWidget);
      expect(find.text('Every gentle pause you complete will appear here.'), findsOneWidget);

      // Verify NO stressful or aggressive copy exists
      expect(find.textContaining('BREAK YOUR STREAK'), findsNothing);
      expect(find.textContaining('anxiety improved'), findsNothing);
    });

    testWidgets('2. Populated progress: displays streak, metrics, chart bars, and history items', (tester) async {
      final now = DateTime.now();

      await progressRepo.recordSession(SessionRecord(
        id: 'rec_1',
        sessionId: 'session_5m_calm_mind',
        sessionTitle: 'Calm Your Mind',
        sessionType: SessionType.guidedMeditation,
        startedAt: now.subtract(const Duration(minutes: 5)),
        completedAt: now,
        durationCompletedSeconds: 300,
        wasCompleted: true,
        moodBefore: MoodType.stressed,
        moodAfter: ReflectionMood.moreRelaxed,
      ));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Streak updated to 1 day
      expect(find.text('1 day of showing up 🌱'), findsOneWidget);

      // History item is rendered
      expect(find.byType(SessionRecordCard), findsOneWidget);
      expect(find.text('Calm Your Mind'), findsOneWidget);
      expect(find.text('😌 More relaxed'), findsOneWidget);

      // Tap on history item to open details modal
      await tester.tap(find.byType(SessionRecordCard));
      await tester.pumpAndSettle();

      // Verify details modal
      expect(find.byType(SessionRecordDetailsModal), findsOneWidget);
      expect(find.text('Check-in before'), findsOneWidget);
      expect(find.text('😟 Stressed'), findsOneWidget);
      expect(find.text('Reflection after'), findsOneWidget);
      expect(find.text('😌 More relaxed'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(SessionRecordDetailsModal), findsNothing);
    });

    testWidgets('3. Delete record: user can delete a practice record from details modal', (tester) async {
      final now = DateTime.now();

      await progressRepo.recordSession(SessionRecord(
        id: 'rec_to_delete',
        sessionId: 'session_1m_reset',
        sessionTitle: 'One Minute Reset',
        sessionType: SessionType.guidedMeditation,
        startedAt: now.subtract(const Duration(minutes: 1)),
        completedAt: now,
        durationCompletedSeconds: 60,
        wasCompleted: true,
      ));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('One Minute Reset'), findsOneWidget);

      // Open details modal
      await tester.tap(find.byType(SessionRecordCard));
      await tester.pumpAndSettle();

      // Tap delete icon
      final deleteBtn = find.byTooltip('Delete record');
      expect(deleteBtn, findsOneWidget);
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      // Confirmation dialog appears
      expect(find.text('Remove practice record?'), findsOneWidget);
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Verify item deleted and snackbar shown
      expect(find.text('Practice record removed.'), findsOneWidget);
      expect(find.text('No practice history yet'), findsOneWidget);
    });
  });
}
