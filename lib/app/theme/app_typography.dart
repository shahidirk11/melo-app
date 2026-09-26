import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography hierarchy for Melo.
/// Clean modern sans-serif styling prioritizing serenity, clarity, and readability.
abstract class AppTypography {
  static const TextStyle display = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.25,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.35,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.45,
    color: AppColors.mutedText,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.4,
    color: AppColors.mutedText,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
    color: Colors.white,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.4,
    color: AppColors.mutedText,
  );

  /// Helper to get a text style colored appropriately for dark mode surfaces.
  static TextStyle forDark(TextStyle base, {bool muted = false}) {
    return base.copyWith(
      color: muted ? AppColors.darkTextMuted : AppColors.darkTextPrimary,
    );
  }

  /// Theme-adaptive bodySmall helper ensuring accessible contrast in light and dark mode.
  static TextStyle bodySmallOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return bodySmall.copyWith(
      color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
    );
  }

  /// Theme-adaptive caption helper ensuring accessible contrast in light and dark mode.
  static TextStyle captionOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return caption.copyWith(
      color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
    );
  }
}
