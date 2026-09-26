import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/session_model.dart';
import '../../../../shared/widgets/melo_badge.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_chip.dart';
import '../../../../shared/widgets/melo_icon_button.dart';
import '../../../../shared/widgets/melo_section_header.dart';
import '../../../../shared/widgets/melo_snackbar.dart';
import 'category_pills_bar.dart';

class SessionDetailsModal extends StatefulWidget {
  const SessionDetailsModal({
    super.key,
    required this.session,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final Session session;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  State<SessionDetailsModal> createState() => _SessionDetailsModalState();
}

class _SessionDetailsModalState extends State<SessionDetailsModal> {
  late bool _currentIsFavorite;

  @override
  void initState() {
    super.initState();
    _currentIsFavorite = widget.isFavorite;
  }

  void _handleToggleFavorite() {
    setState(() {
      _currentIsFavorite = !_currentIsFavorite;
    });
    widget.onToggleFavorite();
    MeloSnackbar.show(
      context,
      message: _currentIsFavorite
          ? 'Saved to favorites'
          : 'Removed from favorites',
      type: MeloSnackbarType.info,
    );
  }

  String _formatTimestamp(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Badges, Favorite Button, and Close Button
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CategoryPillsBar.getCategoryIcon(session.category),
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              MeloBadge(
                label: session.category.displayName,
                variant: MeloBadgeVariant.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              MeloBadge(
                label: '${session.durationMinutes} min',
                variant: MeloBadgeVariant.surface,
              ),
              if (session.difficulty != SessionDifficulty.allLevels) ...[
                const SizedBox(width: AppSpacing.xs),
                MeloBadge(
                  label: session.difficulty.displayName,
                  variant: MeloBadgeVariant.outline,
                ),
              ],
              const Spacer(),
              MeloIconButton(
                icon: _currentIsFavorite
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: _currentIsFavorite
                    ? AppColors.primary
                    : (isDark ? AppColors.darkMutedText : AppColors.mutedText),
                tooltip: _currentIsFavorite ? 'Remove from favorites' : 'Save to favorites',
                onPressed: _handleToggleFavorite,
              ),
              MeloIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close details',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(
            session.title,
            style: AppTypography.heading1.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Type & Overview
          Text(
            session.type.displayName,
            style: AppTypography.labelLarge.copyWith(
              color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Description
          Text(
            session.description,
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.darkText : AppColors.deepText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Tags
          if (session.tags.isNotEmpty) ...[
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: session.tags.map((tag) {
                return MeloChip(
                  label: '#$tag',
                  isSelected: false,
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Practice Flow (Guidance Steps Preview)
          if (session.guidanceSteps.isNotEmpty) ...[
            const MeloSectionHeader(title: 'Practice Flow'),
            const SizedBox(height: AppSpacing.xs),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceHighlight
                    : AppColors.secondarySurface,
                borderRadius: AppSpacing.roundedMedium,
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: session.guidanceSteps.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final step = entry.value;
                  final isLast = idx == session.guidanceSteps.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: AppSpacing.roundedSmall,
                          ),
                          child: Center(
                            child: Text(
                              _formatTimestamp(step.startSecond),
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.instruction,
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (step.subtext != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  step.subtext!,
                                  style: AppTypography.caption.copyWith(
                                    color: isDark
                                        ? AppColors.darkMutedText
                                        : AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Primary CTA Button: Launches Production Session Engine
          MeloButton(
            label: 'Begin Practice',
            icon: Icons.play_arrow_rounded,
            variant: MeloButtonVariant.primary,
            isFullWidth: true,
            onPressed: () {
              Navigator.of(context).pop();
              context.push(AppRoutes.sessionPath(session.id));
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
