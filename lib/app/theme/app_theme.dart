import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// App theme configurations for Melo.
abstract class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.warmBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.softAccent,
        onSecondary: AppColors.deepText,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.secondarySurface,
        onSurface: AppColors.deepText,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: AppColors.deepText),
        headlineLarge: AppTypography.heading1.copyWith(color: AppColors.deepText),
        headlineMedium: AppTypography.heading2.copyWith(color: AppColors.deepText),
        headlineSmall: AppTypography.heading3.copyWith(color: AppColors.deepText),
        titleLarge: AppTypography.heading3.copyWith(color: AppColors.deepText),
        bodyLarge: AppTypography.body.copyWith(color: AppColors.deepText),
        bodyMedium: AppTypography.bodySmall.copyWith(color: AppColors.mutedText),
        bodySmall: AppTypography.caption.copyWith(color: AppColors.mutedText),
        labelLarge: AppTypography.button,
        labelSmall: AppTypography.overline.copyWith(color: AppColors.mutedText),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.warmBackground,
        foregroundColor: AppColors.deepText,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: AppTypography.heading2,
      ),
      cardTheme: CardTheme(
        color: AppColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
          side: const BorderSide(color: Color(0xFFE5E9E1), width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: AppSpacing.buttonPadding,
          textStyle: AppTypography.button,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedButton,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepText,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: AppSpacing.buttonPadding,
          textStyle: AppTypography.button.copyWith(color: AppColors.deepText),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedButton,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.button.copyWith(color: AppColors.primary),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondarySurface,
        disabledColor: AppColors.secondarySurface.withOpacity(0.5),
        selectedColor: AppColors.primaryLight.withOpacity(0.25),
        secondarySelectedColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedSmall,
          side: const BorderSide(color: Colors.transparent),
        ),
        labelStyle: AppTypography.bodySmall.copyWith(color: AppColors.deepText),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.warmBackground,
        indicatorColor: AppColors.primaryLight.withOpacity(0.3),
        elevation: 0,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTypography.caption.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.caption.copyWith(color: AppColors.mutedText);
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.primaryDark, size: 24);
          }
          return const IconThemeData(color: AppColors.mutedText, size: 24);
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkBackground,
        secondary: AppColors.darkAccent,
        onSecondary: AppColors.darkBackground,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: AppColors.darkTextPrimary),
        headlineLarge: AppTypography.heading1.copyWith(color: AppColors.darkTextPrimary),
        headlineMedium: AppTypography.heading2.copyWith(color: AppColors.darkTextPrimary),
        headlineSmall: AppTypography.heading3.copyWith(color: AppColors.darkTextPrimary),
        titleLarge: AppTypography.heading3.copyWith(color: AppColors.darkTextPrimary),
        bodyLarge: AppTypography.body.copyWith(color: AppColors.darkTextPrimary),
        bodyMedium: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
        bodySmall: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
        labelLarge: AppTypography.button.copyWith(color: AppColors.darkBackground),
        labelSmall: AppTypography.overline.copyWith(color: AppColors.darkTextMuted),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          height: 1.35,
          color: AppColors.darkTextPrimary,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
          side: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          padding: AppSpacing.buttonPadding,
          textStyle: AppTypography.button.copyWith(color: AppColors.darkBackground),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedButton,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
          padding: AppSpacing.buttonPadding,
          textStyle: AppTypography.button.copyWith(color: AppColors.darkTextPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedButton,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          textStyle: AppTypography.button.copyWith(color: AppColors.darkPrimary),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceHighlight,
        disabledColor: AppColors.darkSurfaceHighlight.withOpacity(0.5),
        selectedColor: AppColors.darkPrimary.withOpacity(0.3),
        secondarySelectedColor: AppColors.darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedSmall,
          side: const BorderSide(color: Colors.transparent),
        ),
        labelStyle: AppTypography.bodySmall.copyWith(color: AppColors.darkTextPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        indicatorColor: AppColors.darkPrimary.withOpacity(0.25),
        elevation: 0,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTypography.caption.copyWith(
              color: AppColors.darkPrimary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.caption.copyWith(color: AppColors.darkTextMuted);
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.darkPrimary, size: 24);
          }
          return const IconThemeData(color: AppColors.darkTextMuted, size: 24);
        }),
      ),
    );
  }
}
