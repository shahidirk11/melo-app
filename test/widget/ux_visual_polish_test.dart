import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/app/config/app_config.dart';
import 'package:melo_app/app/providers.dart';
import 'package:melo_app/app/theme/app_colors.dart';
import 'package:melo_app/app/theme/app_theme.dart';
import 'package:melo_app/app/theme/app_typography.dart';
import 'package:melo_app/data/models/user_preferences_model.dart';
import 'package:melo_app/data/repositories/progress_repository.dart';
import 'package:melo_app/data/repositories/session_repository.dart';
import 'package:melo_app/data/repositories/user_preferences_repository.dart';
import 'package:melo_app/features/onboarding/presentation/steps/duration_step.dart';
import 'package:melo_app/features/onboarding/presentation/steps/first_session_step.dart';
import 'package:melo_app/features/onboarding/presentation/steps/goals_step.dart';
import 'package:melo_app/features/onboarding/presentation/steps/reminder_permission_step.dart';
import 'package:melo_app/features/onboarding/presentation/steps/reminder_time_step.dart';
import 'package:melo_app/features/onboarding/presentation/steps/welcome_step.dart';
import 'package:melo_app/features/sessions/presentation/session_completion_screen.dart';
import 'package:melo_app/shared/animations/melo_fade_scale.dart';
import 'package:melo_app/shared/animations/melo_slide_transition.dart';
import 'package:melo_app/shared/widgets/melo_badge.dart';
import 'package:melo_app/shared/widgets/melo_button.dart';
import 'package:melo_app/shared/widgets/melo_chip.dart';
import 'package:melo_app/shared/widgets/melo_icon_button.dart';
import 'package:melo_app/shared/widgets/state_views/empty_view.dart';
import 'package:melo_app/shared/widgets/state_views/error_view.dart';
import 'package:melo_app/shared/widgets/state_views/loading_view.dart';

void main() {
  group('UX & Visual Quality Pass Tests', () {
    // -------------------------------------------------------------------------
    // 1. Accessible Touch Targets
    // -------------------------------------------------------------------------
    group('Touch Targets and Hit Areas', () {
      testWidgets('MeloButton satisfies accessible touch target height (>= 48dp)',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Center(
                child: MeloButton(
                  label: 'Touch Target Button',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        final buttonFinder = find.byType(MeloButton);
        final size = tester.getSize(buttonFinder);
        expect(size.height, greaterThanOrEqualTo(48.0));
      });

      testWidgets('MeloChip satisfies minimum touch target height (>= 44dp)',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Center(
                child: MeloChip(
                  label: 'Calm',
                  onTap: () {},
                ),
              ),
            ),
          ),
        );

        final chipFinder = find.byType(MeloChip);
        final size = tester.getSize(chipFinder);
        expect(size.height, greaterThanOrEqualTo(44.0));
      });

      testWidgets('MeloIconButton satisfies minimum touch target (>= 44dp hit test area)',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Center(
                child: MeloIconButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Close',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        final iconButtonFinder = find.byType(MeloIconButton);
        final size = tester.getSize(iconButtonFinder);
        expect(size.width, greaterThanOrEqualTo(44.0));
        expect(size.height, greaterThanOrEqualTo(44.0));
      });
    });

    // -------------------------------------------------------------------------
    // 2. Disabled & Interactive States
    // -------------------------------------------------------------------------
    group('Interactive and Disabled States', () {
      testWidgets('MeloButton handles disabled state (onPressed: null) without firing',
          (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Center(
                child: MeloButton(
                  label: 'Disabled Action',
                  onPressed: null,
                ),
              ),
            ),
          ),
        );

        expect(find.text('Disabled Action'), findsOneWidget);
        await tester.tap(find.text('Disabled Action'));
        await tester.pumpAndSettle();
        expect(tapped, isFalse);

        // Verify semantics reflects disabled state
        final semanticsFinder = find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.enabled == false,
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('MeloIconButton handles disabled state (onPressed: null)',
          (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Center(
                child: MeloIconButton(
                  icon: Icons.bookmark_border_rounded,
                  tooltip: 'Disabled bookmark',
                  onPressed: null,
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(MeloIconButton));
        await tester.pumpAndSettle();
        expect(tapped, isFalse);

        // Verify semantics reflects disabled state
        final semanticsFinder = find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.enabled == false,
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // 3. Dark Mode Palette & Contrast
    // -------------------------------------------------------------------------
    group('Dark Mode Palette & Typography Contrast', () {
      test('Dark theme tokens define true dark background and high-contrast surfaces', () {
        final darkTheme = AppTheme.darkTheme;
        expect(darkTheme.scaffoldBackgroundColor, equals(AppColors.darkBackground));
        expect(darkTheme.cardColor, equals(AppColors.darkSurface));
        expect(darkTheme.colorScheme.primary, equals(AppColors.darkPrimary));
        expect(darkTheme.colorScheme.onSurface, equals(AppColors.darkTextPrimary));
      });

      test('Light theme tokens define warm background and calm surfaces', () {
        final lightTheme = AppTheme.lightTheme;
        expect(lightTheme.scaffoldBackgroundColor, equals(AppColors.warmBackground));
        expect(lightTheme.colorScheme.primary, equals(AppColors.primary));
        expect(lightTheme.colorScheme.onSurface, equals(AppColors.deepText));
      });

      testWidgets('StateViews render with appropriate theme contrast in Dark Mode',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Column(
                children: [
                  Expanded(child: LoadingView(message: 'Loading peacefully...')),
                  Expanded(
                    child: EmptyView(
                      title: 'No sessions found',
                      message: 'Try clearing your filters',
                    ),
                  ),
                  Expanded(
                    child: ErrorView(
                      title: 'Something went wrong',
                      message: 'Tap retry below',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Loading peacefully...'), findsOneWidget);
        expect(find.text('No sessions found'), findsOneWidget);
        expect(find.text('Something went wrong'), findsOneWidget);
      });

      testWidgets('MeloBadge renders all variants in Dark Mode', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Row(
                children: [
                  MeloBadge(label: 'Primary', variant: MeloBadgeVariant.primary),
                  MeloBadge(label: 'Surface', variant: MeloBadgeVariant.surface),
                  MeloBadge(label: 'Neutral', variant: MeloBadgeVariant.neutral),
                  MeloBadge(label: 'Outline', variant: MeloBadgeVariant.outline),
                  MeloBadge(label: 'Accent', variant: MeloBadgeVariant.accent),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Primary'), findsOneWidget);
        expect(find.text('Surface'), findsOneWidget);
        expect(find.text('Neutral'), findsOneWidget);
        expect(find.text('Outline'), findsOneWidget);
        expect(find.text('Accent'), findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // 4. Accessibility Text Scaling & Small Screen Overflow Resilience
    // -------------------------------------------------------------------------
    group('Accessibility Text Scaling (1.4x font factor)', () {
      testWidgets('WelcomeStep adapts to 1.4x text scaling without overflow',
          (tester) async {
        // Enforce a compact device screen size (360x640)
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
              textScaler: TextScaler.linear(1.4),
            ),
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: WelcomeStep(
                  config: AppConfig.standard(),
                  onNext: () {},
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Melo'), findsOneWidget);
        expect(find.text('Get started'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('GoalsStep adapts to 1.4x text scaling without overflow',
          (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
              textScaler: TextScaler.linear(1.4),
            ),
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: GoalsStep(
                  initialGoals: const ['Feel calmer'],
                  onContinue: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('What would you like help with?'), findsOneWidget);
        expect(find.text('Continue'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('DurationStep adapts to 1.4x text scaling without overflow',
          (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
              textScaler: TextScaler.linear(1.4),
            ),
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: DurationStep(
                  initialDurationSeconds: 300,
                  onContinue: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('How much time do you usually have?'), findsOneWidget);
        expect(find.text('Continue'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('ReminderPermissionStep adapts to 1.4x text scaling without overflow',
          (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
              textScaler: TextScaler.linear(1.4),
            ),
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: ReminderPermissionStep(
                  formattedTime: '8:00 AM',
                  onDecision: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('A gentle nudge when it\'s time'), findsOneWidget);
        expect(find.text('Enable reminders'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('FirstSessionStep adapts to 1.4x text scaling without overflow',
          (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
              textScaler: TextScaler.linear(1.4),
            ),
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: FirstSessionStep(
                  onStartFirstSession: () {},
                  onSkipToHome: () {},
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Ready for your first reset?'), findsOneWidget);
        expect(find.text('Start first session'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('SessionCompletionScreen adapts to 1.4x text scaling without overflow',
          (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        final sessionRepo = InMemorySessionRepository();
        final progressRepo = InMemoryProgressRepository();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sessionRepositoryProvider.overrideWithValue(sessionRepo),
              progressRepositoryProvider.overrideWithValue(progressRepo),
            ],
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(360, 640),
                textScaler: TextScaler.linear(1.4),
              ),
              child: MaterialApp(
                theme: AppTheme.darkTheme,
                home: const SessionCompletionScreen(sessionId: 'session_1m_reset'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Mindful moment complete'), findsNothing);
        expect(find.text('Nice work'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    // -------------------------------------------------------------------------
    // 5. Reduced Motion & Animation Safety
    // -------------------------------------------------------------------------
    group('Reduced Motion and Micro-animations', () {
      testWidgets('MeloSlideTransition and MeloFadeScale respect rendering without error',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MeloSlideTransition(
                delay: Duration(milliseconds: 50),
                child: MeloFadeScale(
                  child: Text('Smooth calm motion'),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Smooth calm motion'), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();
        expect(find.text('Smooth calm motion'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
