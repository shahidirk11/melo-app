/// Centralized route paths for GoRouter.
abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Bottom Navigation Shell Routes
  static const String home = '/home';
  static const String explore = '/explore';
  static const String progress = '/progress';
  static const String profile = '/profile';

  // Explore sub-routes
  static const String exploreCategory = '/explore/category/:category';

  // Profile sub-routes
  static const String profilePreferences = '/profile/preferences';
  static const String profileReminders = '/profile/reminders';
  static const String profileAudio = '/profile/audio';
  static const String profilePrivacy = '/profile/privacy';

  // Dedicated Full-Screen Session Flows (outside shell)
  static const String session = '/session/:id';
  static const String sessionComplete = '/session/:id/complete';

  // Helper route generators
  static String sessionPath(String id) => '/session/$id';
  static String sessionCompletePath(String id) => '/session/$id/complete';
  static String exploreCategoryPath(String category) => '/explore/category/$category';
}
