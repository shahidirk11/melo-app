import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/session_model.dart';
import '../../../../shared/widgets/melo_badge.dart';
import '../../../../shared/widgets/melo_card.dart';
import '../../../../shared/widgets/melo_icon_button.dart';
import 'category_pills_bar.dart';

class ExploreSessionCard extends StatelessWidget {
  const ExploreSessionCard({
    super.key,
    required this.session,
    required this.isFavorite,
    required this.onTap,
    required this.onPlay,
    required this.onToggleFavorite,
  });

  final Session session;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onPlay;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MeloCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceHighlight
                      : AppColors.secondarySurface,
                  borderRadius: AppSpacing.roundedSmall,
                ),
                child: Icon(
                  CategoryPillsBar.getCategoryIcon(session.category),
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: AppTypography.heading3.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Favorite & Play Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MeloIconButton(
                    icon: isFavorite
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isFavorite
                        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                        : (isDark ? AppColors.darkMutedText : AppColors.mutedText),
                    tooltip: isFavorite ? 'Remove bookmark' : 'Bookmark practice',
                    onPressed: onToggleFavorite,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  MeloIconButton(
                    icon: Icons.play_arrow_rounded,
                    variant: MeloIconButtonVariant.filled,
                    size: 38,
                    iconSize: 22,
                    tooltip: 'Start ${session.title}',
                    onPressed: onPlay,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Metadata Badges Row
          Row(
            children: [
              MeloBadge(
                label: '${session.durationMinutes} min',
                variant: MeloBadgeVariant.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              MeloBadge(
                label: session.category.displayName,
                variant: MeloBadgeVariant.surface,
              ),
              if (session.difficulty != SessionDifficulty.allLevels) ...[
                const SizedBox(width: AppSpacing.xs),
                MeloBadge(
                  label: session.difficulty.displayName,
                  variant: MeloBadgeVariant.outline,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
