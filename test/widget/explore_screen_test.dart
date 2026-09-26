import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/core/services/audio/in_memory_audio_service.dart';
import 'package:melo_app/app/router/app_router.dart';
import 'package:melo_app/app/theme/app_theme.dart';
import 'package:melo_app/data/models/mood_entry_model.dart';
import 'package:melo_app/data/models/session_model.dart';
import 'package:melo_app/data/repositories/breathing_pattern_repository.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/explore/presentation/explore_screen.dart';
import 'package:melo_app/features/explore/presentation/widgets/category_pills_bar.dart';
import 'package:melo_app/features/explore/presentation/widgets/explore_search_bar.dart';
import 'package:melo_app/features/explore/presentation/widgets/explore_session_card.dart';
import 'package:melo_app/features/explore/presentation/widgets/session_details_modal.dart';
import 'package:melo_app/features/sessions/presentation/active_session_screen.dart';
import 'package:melo_app/features/sessions/presentation/session_completion_screen.dart';
import 'package:melo_app/features/sessions/presentation/session_provider.dart';

void main() {
  group('ExploreScreen Widget Tests', () {
    late InMemorySessionRepository sessionRepo;
    late InMemoryProgressRepository progressRepo;
    late InMemoryBreathingPatternRepository breathingRepo;
    late InMemoryUserPreferencesRepository userRepo;

    setUp(() {
      sessionRepo = InMemorySessionRepository();
      progressRepo = InMemoryProgressRepository();
      breathingRepo = InMemoryBreathingPatternRepository();
      userRepo = InMemoryUserPreferencesRepository();
    });

    Widget createExploreTestWidget() {
      return ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(sessionRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          breathingPatternRepositoryProvider.overrideWithValue(breathingRepo),
          userPreferencesRepositoryProvider.overrideWithValue(userRepo),
          audioServiceProvider.overrideWithValue(InMemoryAudioService()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ExploreScreen(),
        ),
      );
    }

    Widget createExploreRouterWidget() {
      return ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(sessionRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          breathingPatternRepositoryProvider.overrideWithValue(breathingRepo),
          userPreferencesRepositoryProvider.overrideWithValue(userRepo),
          audioServiceProvider.overrideWithValue(InMemoryAudioService()),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              theme: AppTheme.lightTheme,
              routerConfig: router,
            );
          },
        ),
      );
    }

    testWidgets('1. Browse: renders header, categories, search bar, and session cards', (tester) async {
      await tester.pumpWidget(createExploreTestWidget());
      await tester.pumpAndSettle();

      // Check header
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Mindful practices for every part of your day'), findsOneWidget);

      // Check search bar
      expect(find.byType(ExploreSearchBar), findsOneWidget);

      // Check Category Pills
      expect(find.byType(CategoryPillsBar), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Calm'), findsWidgets);

      // Check Session cards
      expect(find.byType(ExploreSessionCard), findsWidgets);
    });

    testWidgets('2. Categories: tapping Sleep category filters list to sleep sessions', (tester) async {
      await tester.pumpWidget(createExploreTestWidget());
      await tester.pumpAndSettle();

      // Tap "Sleep" category pill
      final sleepPill = find.widgetWithText(CategoryPillsBar, 'Sleep');
      if (sleepPill.evaluate().isEmpty) {
        await tester.drag(find.byType(CategoryPillsBar), const Offset(-200, 0));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.widgetWithText(CategoryPillsBar, 'Sleep'));
      await tester.pumpAndSettle();

      // All visible sessions should be sleep category
      final cards = tester.widgetList<ExploreSessionCard>(find.byType(ExploreSessionCard));
      expect(cards.isNotEmpty, isTrue);
      for (final card in cards) {
        expect(card.session.category, SessionCategory.sleep);
      }
    });

    testWidgets('3. Search: typing query filters list across title, desc, and tags', (tester) async {
      await tester.pumpWidget(createExploreTestWidget());
      await tester.pumpAndSettle();

      // Enter search term
      await tester.enterText(find.byType(TextField), 'Box');
      await tester.pumpAndSettle();

      // Verify matching session appears
      expect(find.text('Box Breathing Reset'), findsOneWidget);

      // Clear search
      final clearBtn = find.byTooltip('Clear search');
      expect(clearBtn, findsOneWidget);
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      // Full list is restored
      expect(tester.widgetList(find.byType(ExploreSessionCard)).length, greaterThan(1));
    });

    testWidgets('4. Filtering: Duration chip filters sessions', (tester) async {
      await tester.pumpWidget(createExploreTestWidget());
      await tester.pumpAndSettle();

      // Tap 1–3 min duration chip
      final durationChip = find.text('1–3 min');
      expect(durationChip, findsOneWidget);
      await tester.tap(durationChip);
      await tester.pumpAndSettle();

      final cards = tester.widgetList<ExploreSessionCard>(find.byType(ExploreSessionCard));
      expect(cards.isNotEmpty, isTrue);
      for (final card in cards) {
        expect(card.session.durationSeconds, lessThanOrEqualTo(180));
      }
    });

    testWidgets('5. Favorites: toggle favorite directly on card and filter favorites', (tester) async {
      await tester.pumpWidget(createExploreTestWidget());
      await tester.pumpAndSettle();

      // Tap bookmark on the first card
      final firstBookmark = find.byTooltip('Bookmark practice').first;
      await tester.tap(firstBookmark);
      await tester.pumpAndSettle();

      // Verify snackbar
      expect(find.text('Saved to favorites'), findsOneWidget);

      // Now filter by favorites
      final favChip = find.widgetWithText(MeloChip, 'Favorites');
      await tester.tap(favChip);
      await tester.pumpAndSettle();

      // Only 1 card is displayed
      expect(find.byType(ExploreSessionCard), findsOneWidget);

      // Remove bookmark directly from card
      final removeBookmark = find.byTooltip('Remove bookmark').first;
      await tester.tap(removeBookmark);
      await tester.pumpAndSettle();

      // Empty state appears
      expect(find.text('No saved favorites yet'), findsOneWidget);
      expect(find.text('Browse all practices'), findsOneWidget);

      // Tap "Browse all practices"
      await tester.tap(find.text('Browse all practices'));
      await tester.pumpAndSettle();

      // Full list is back
      expect(find.byType(ExploreSessionCard), findsWidgets);
    });

    testWidgets('6. Session Details: tap card to open modal and toggle favorite inside modal', (tester) async {
      await tester.pumpWidget(createExploreTestWidget());
      await tester.pumpAndSettle();

      // Tap first card to open details
      await tester.tap(find.byType(ExploreSessionCard).first);
      await tester.pumpAndSettle();

      // Verify SessionDetailsModal is displayed
      expect(find.byType(SessionDetailsModal), findsOneWidget);
      expect(find.text('Practice Flow'), findsOneWidget);
      expect(find.text('Begin Practice'), findsOneWidget);

      // Toggle favorite inside modal
      final modalBookmark = find.descendant(
        of: find.byType(SessionDetailsModal),
        matching: find.byTooltip('Save to favorites'),
      );
      expect(modalBookmark, findsOneWidget);
      await tester.tap(modalBookmark);
      await tester.pumpAndSettle();

      // Verify snackbar
      expect(find.text('Saved to favorites'), findsOneWidget);
    });

    testWidgets('7. Opening & Completing session from Explore uses production session engine', (tester) async {
      await tester.pumpWidget(createExploreRouterWidget());
      await tester.pumpAndSettle();

      // Switch to Explore tab in bottom navigation shell
      final exploreNav = find.byIcon(Icons.explore_outlined);
      await tester.tap(exploreNav);
      await tester.pumpAndSettle();

      expect(find.text('Explore'), findsOneWidget);
      expect(find.byType(ExploreSessionCard), findsWidgets);

      // Tap play button directly on the first card
      final playBtn = find.descendant(
        of: find.byType(ExploreSessionCard).first,
        matching: find.byIcon(Icons.play_arrow_rounded),
      );
      await tester.tap(playBtn);
      await tester.pumpAndSettle();

      // Verify production ActiveSessionScreen opened with intro dialog
      expect(find.byType(ActiveSessionScreen), findsOneWidget);
      expect(find.text('Before we begin...'), findsOneWidget);

      // Start session
      await tester.tap(find.text('Begin'));
      await tester.pumpAndSettle();

      // Verify production session engine state is playing
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

      // Fast-forward completion
      final container = ProviderScope.containerOf(tester.element(find.byType(ActiveSessionScreen)));
      await container.read(sessionEngineProvider.notifier).completeSession();
      await tester.pumpAndSettle();

      // Verify production SessionCompletionScreen opened
      expect(find.byType(SessionCompletionScreen), findsOneWidget);
      expect(find.text('Nice work 🌿'), findsOneWidget);
      expect(find.text('How do you feel now?'), findsOneWidget);

      // Tap reflection mood "😌 More relaxed"
      await tester.tap(find.text('😌 More relaxed'));
      await tester.pumpAndSettle();

      // Tap "Try another reset" to return to Explore
      await tester.tap(find.text('Try another reset'));
      await tester.pumpAndSettle();

      // Returned to Explore screen!
      expect(find.byType(ExploreScreen), findsOneWidget);

      // Verify session completion was recorded in progress repository
      final records = await progressRepo.getHistory();
      expect(records.isNotEmpty, isTrue);
      expect(records.first.wasCompleted, isTrue);
      expect(records.first.moodAfter, ReflectionMood.moreRelaxed);
    });
  });
}
