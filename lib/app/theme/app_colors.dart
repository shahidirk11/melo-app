import 'package:flutter/material.dart';

/// Semantic color tokens for Melo.
/// Follows the product specification design system tokens:
/// Primary: #6F8F78, Deep text: #1E2722, Warm background: #F7F6F1,
/// Secondary surface: #EEF1EB, Soft accent: #DCC9A4, Muted text: #768078.
abstract class AppColors {
  // Light Palette Tokens
  static const Color primary = Color(0xFF6F8F78);
  static const Color primaryDark = Color(0xFF55745E);
  static const Color primaryLight = Color(0xFF8BA793);

  static const Color deepText = Color(0xFF1E2722);
  static const Color mutedText = Color(0xFF768078);
  static const Color warmBackground = Color(0xFFF7F6F1);
  static const Color secondarySurface = Color(0xFFEEF1EB);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color surface = cardSurface;
  static const Color softAccent = Color(0xFFDCC9A4);
  static const Color softAccentLight = Color(0xFFEBE0C8);

  // Dark Palette Tokens (True Dark Mode, not inverted)
  static const Color darkBackground = Color(0xFF131915);
  static const Color darkSurface = Color(0xFF1C2420);
  static const Color darkSurfaceHighlight = Color(0xFF26302B);
  static const Color darkTextPrimary = Color(0xFFEBEFEA);
  static const Color darkText = Color(0xFFEBEFEA);
  static const Color darkTextMuted = Color(0xFF9BA89F);
  static const Color darkMutedText = Color(0xFF9BA89F);
  static const Color darkPrimary = Color(0xFF7EA288);
  static const Color darkAccent = Color(0xFFE2D2B3);

  // Border Tokens
  static const Color subtleBorder = Color(0xFFE2E7E0);
  static const Color darkBorder = Color(0xFF2A3630);

  // Functional Semantic Tokens
  static const Color success = Color(0xFF5A8E68);
  static const Color warning = Color(0xFFD49A58);
  static const Color error = Color(0xFFBA5A5A);
  static const Color info = Color(0xFF60809A);

  // Mood Tokens (Gentle, desaturated tones)
  static const Color moodCalm = Color(0xFF7FA38D);
  static const Color moodGood = Color(0xFF88A89A);
  static const Color moodOkay = Color(0xFFB5AC8E);
  static const Color moodStressed = Color(0xFFC78B76);
  static const Color moodTired = Color(0xFF8896A6);
}
