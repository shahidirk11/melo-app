import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/session_state.dart';

class BreathingCircleVisualizer extends StatelessWidget {
  const BreathingCircleVisualizer({
    super.key,
    required this.phase,
    required this.remainingFormatted,
    this.isReducedMotion = false,
    this.isPlaying = true,
  });

  final BreathingPhase phase;
  final String remainingFormatted;
  final bool isReducedMotion;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final systemDisableAnim = MediaQuery.of(context).disableAnimations;
    final shouldReduceMotion = isReducedMotion || systemDisableAnim;

    // Target scale calculation based on phase
    final targetScale = shouldReduceMotion
        ? 1.0
        : (isPlaying ? phase.endScale : 1.0);

    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Ambient Aura Ring
            AnimatedScale(
              scale: targetScale * 1.15,
              duration: Duration(
                milliseconds: shouldReduceMotion ? 0 : 2500,
              ),
              curve: Curves.easeInOutSine,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.darkPrimary.withOpacity(0.08)
                      : AppColors.primaryLight.withOpacity(0.12),
                ),
              ),
            ),

            // Middle Breathing Ring
            AnimatedScale(
              scale: targetScale,
              duration: Duration(
                milliseconds: shouldReduceMotion ? 0 : 2000,
              ),
              curve: Curves.easeInOutCubic,
              child: Container(
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.darkPrimary.withOpacity(0.18)
                      : AppColors.primaryLight.withOpacity(0.24),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkPrimary.withOpacity(0.35)
                        : AppColors.primary.withOpacity(0.35),
                    width: 2.0,
                  ),
                ),
              ),
            ),

            // Center Content: Timer and Phase Label
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  remainingFormatted,
                  style: AppTypography.display.copyWith(
                    fontSize: 32,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isPlaying ? phase.label : 'Paused',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkPrimary : AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
