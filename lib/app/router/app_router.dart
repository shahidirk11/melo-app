import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/explore/presentation/explore_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/reminders/presentation/reminders_screen.dart';
import '../../features/sessions/presentation/active_session_screen.dart';
import '../../features/sessions/presentation/session_completion_screen.dart';
import '../../features/shell/presentation/app_shell_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../shared/widgets/state_views/error_view.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
  final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'homeNav');
  final exploreNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'exploreNav');
  final progressNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'progressNav');
  final profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profileNav');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    errorBuilder: (context, state) => Scaffold(
      body: ErrorView(
        title: 'Screen not found',
        message: 'The page you were looking for doesn\'t exist.',
        retryLabel: 'Go home',
        onRetry: () => context.go(AppRoutes.home),
      ),
    ),
    routes: [
      // 1. Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // 2. Onboarding Screen
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // 3. Bottom Navigation App Shell (Home, Explore, Progress, Profile)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: exploreNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: progressNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // 4. Dedicated Full-Screen Session Player (Outside bottom nav shell)
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.session,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'session_1m_reset';
          return ActiveSessionScreen(sessionId: id);
        },
      ),

      // 5. Dedicated Full-Screen Session Complete & Reflection
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.sessionComplete,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'session_1m_reset';
          return SessionCompletionScreen(sessionId: id);
        },
      ),

      // 6. Mindful Reminders & Notification Settings
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.profileReminders,
        builder: (context, state) => const RemindersScreen(),
      ),
    ],
  );
});
