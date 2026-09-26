import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/melo_responsive_container.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navBarBg = isDark ? AppColors.darkBackground : AppColors.warmBackground;
    final borderColor = isDark
        ? AppColors.darkSurfaceHighlight.withOpacity(0.6)
        : const Color(0xFFE5E9E1);

    return Scaffold(
      body: MeloResponsiveContainer(
        child: navigationShell,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBarBg,
          border: Border(
            top: BorderSide(color: borderColor, width: 1.0),
          ),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            backgroundColor: navBarBg,
            elevation: 0,
            height: 64,
            indicatorColor: isDark
                ? AppColors.darkPrimary.withOpacity(0.25)
                : AppColors.primaryLight.withOpacity(0.3),
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return AppTypography.caption.copyWith(
                  color: isDark ? AppColors.darkPrimary : AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                );
              }
              return AppTypography.caption.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                fontSize: 11,
              );
            }),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.spa_outlined),
                selectedIcon: Icon(
                  Icons.spa_rounded,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                label: 'Home',
                tooltip: 'Home & Daily Reset',
              ),
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: Icon(
                  Icons.explore_rounded,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                label: 'Explore',
                tooltip: 'Explore Practices',
              ),
              NavigationDestination(
                icon: const Icon(Icons.insights_outlined),
                selectedIcon: Icon(
                  Icons.insights_rounded,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                label: 'Progress',
                tooltip: 'Your Mindful Journey',
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                label: 'Profile',
                tooltip: 'Preferences & Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
