import 'package:flutter/material.dart';

/// Elevation and subtle shadow tokens for Melo.
/// Soft, diffused ambient shadows rather than harsh drop shadows
/// to maintain a calm, premium aesthetic.
abstract class AppShadows {
  /// Subtle card elevation for light surfaces
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0A1E2722), // 4% deep text
      blurRadius: 12.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Elevated component shadow for modal sheets, floating pills, and heroes
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x121E2722), // 7% deep text
      blurRadius: 20.0,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x081E2722), // 3% deep text
      blurRadius: 6.0,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Floating control shadow (e.g. snackbars, play buttons)
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x1A1E2722), // 10% deep text
      blurRadius: 24.0,
      offset: Offset(0, 10),
      spreadRadius: -2,
    ),
  ];

  /// Dark mode soft ambient glow/shadow
  static const List<BoxShadow> darkElevated = [
    BoxShadow(
      color: Color(0x40000000), // 25% black
      blurRadius: 16.0,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];
}
