import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/app_config.dart';
import '../../../app/providers.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/animations/melo_fade_scale.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    // Subtle, peaceful launch delay
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final prefs = ref.read(userPreferencesProvider);
    if (prefs.onboardingCompleted) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: MeloFadeScale(
          duration: const Duration(milliseconds: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.spa_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                config.appName,
                style: AppTypography.display.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                config.tagline,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
