import 'package:flutter/material.dart';

/// Spacing, layout, and touch-target tokens for Melo.
abstract class AppSpacing {
  // Incremental Spacing
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double huge = 48.0;

  // Corner Radii Tokens (Section 5)
  static const double radiusSmall = 12.0;  // Small controls, chips, small badges
  static const double radiusMedium = 16.0; // Interactive controls, medium containers
  static const double radiusButton = 16.0; // Interactive buttons
  static const double radiusCard = 20.0;   // Standard cards
  static const double radiusLarge = 24.0;  // Dialogs, elevated sheets
  static const double radiusHero = 28.0;   // Large hero cards, modals, sheets
  static const double radiusPill = 999.0;  // Circular / Pill shapes

  // Common BorderRadius instances
  static final BorderRadius roundedSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius roundedMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius roundedButton = BorderRadius.circular(radiusButton);
  static final BorderRadius roundedCard = BorderRadius.circular(radiusCard);
  static final BorderRadius roundedLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius roundedHero = BorderRadius.circular(radiusHero);
  static final BorderRadius roundedPill = BorderRadius.circular(radiusPill);

  // Common Sheet Radii (top rounded)
  static const BorderRadius roundedSheet = BorderRadius.only(
    topLeft: Radius.circular(radiusHero),
    topRight: Radius.circular(radiusHero),
  );

  // Accessible Touch Target Tokens (WCAG 2.1 AAA - minimum 48x48)
  static const double minTouchTarget = 48.0;
  static const double iconButtonSize = 44.0;
  static const double smallIconButtonSize = 36.0;

  // Layout Breakpoints
  static const double maxContentWidth = 640.0; // Responsive container max-width for tablet/desktop
  static const double maxCardWidth = 560.0;

  // Common Paddings
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
  static const EdgeInsets screenPaddingWide = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: lg,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}
