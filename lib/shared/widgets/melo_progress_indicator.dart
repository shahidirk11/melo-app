import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class MeloLinearProgressIndicator extends StatelessWidget {
  const MeloLinearProgressIndicator({
    super.key,
    required this.progress, // 0.0 to 1.0
    this.height = 6.0,
    this.backgroundColor,
    this.progressColor,
  });

  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseBg = backgroundColor ??
        (isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface);
    final baseProgress = progressColor ??
        (isDark ? AppColors.darkPrimary : AppColors.primary);

    return ClipRRect(
      borderRadius: AppSpacing.roundedPill,
      child: Container(
        height: height,
        color: baseBg,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final targetWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
            return Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: targetWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: baseProgress,
                    borderRadius: AppSpacing.roundedPill,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MeloCircularProgressIndicator extends StatelessWidget {
  const MeloCircularProgressIndicator({
    super.key,
    required this.progress, // 0.0 to 1.0
    this.size = 120.0,
    this.strokeWidth = 6.0,
    this.child,
    this.progressColor,
    this.trackColor,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Widget? child;
  final Color? progressColor;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedProgressColor = progressColor ??
        (isDark ? AppColors.darkPrimary : AppColors.primary);
    final resolvedTrackColor = trackColor ??
        (isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            backgroundColor: resolvedTrackColor,
            valueColor: AlwaysStoppedAnimation<Color>(resolvedProgressColor),
            strokeCap: StrokeCap.round,
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
