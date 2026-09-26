import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

import 'package:flutter/services.dart';

enum MeloCardStyle {
  standard,
  hero,
  surface,
}

class MeloCard extends StatelessWidget {
  const MeloCard({
    super.key,
    required this.child,
    this.style = MeloCardStyle.standard,
    this.padding = AppSpacing.cardPadding,
    this.onTap,
  });

  final Widget child;
  final MeloCardStyle style;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderRadius = style == MeloCardStyle.hero
        ? AppSpacing.roundedHero
        : AppSpacing.roundedCard;

    final backgroundColor = switch (style) {
      MeloCardStyle.standard =>
        isDark ? AppColors.darkSurface : AppColors.cardSurface,
      MeloCardStyle.hero =>
        isDark ? AppColors.darkSurfaceHighlight : AppColors.secondarySurface,
      MeloCardStyle.surface =>
        isDark ? AppColors.darkBackground : AppColors.warmBackground,
    };

    final border = BorderSide(
      color: isDark ? AppColors.darkBorder : const Color(0xFFE5E9E1),
      width: 1.0,
    );

    final cardContent = Padding(
      padding: padding,
      child: child,
    );

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: border,
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onTap!();
              },
              borderRadius: borderRadius,
              child: cardContent,
            )
          : cardContent,
    );
  }
}
