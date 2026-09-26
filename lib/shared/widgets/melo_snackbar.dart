import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum MeloSnackbarType {
  info,
  success,
  warning,
  error,
}

abstract class MeloSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    MeloSnackbarType type = MeloSnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (bgColor, iconColor, icon) = switch (type) {
      MeloSnackbarType.info => (
          isDark ? AppColors.darkSurfaceHighlight : AppColors.deepText,
          AppColors.softAccent,
          Icons.info_outline_rounded,
        ),
      MeloSnackbarType.success => (
          isDark ? const Color(0xFF1E3324) : const Color(0xFF2A4A33),
          AppColors.primaryLight,
          Icons.check_circle_outline_rounded,
        ),
      MeloSnackbarType.warning => (
          isDark ? const Color(0xFF3B2E1C) : const Color(0xFF4A381C),
          AppColors.warning,
          Icons.warning_amber_rounded,
        ),
      MeloSnackbarType.error => (
          isDark ? const Color(0xFF381F1F) : const Color(0xFF4D2525),
          const Color(0xFFE28B8B),
          Icons.error_outline_rounded,
        ),
    };

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
        ),
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        duration: duration,
        content: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
                child: Text(
                  actionLabel,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.softAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
