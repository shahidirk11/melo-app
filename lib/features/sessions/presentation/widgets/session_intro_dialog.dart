import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/session_model.dart';
import '../../../../shared/widgets/melo_badge.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_card.dart';

class SessionIntroDialog extends StatelessWidget {
  const SessionIntroDialog({
    super.key,
    required this.session,
    required this.onBegin,
    required this.onCancel,
  });

  final Session session;
  final VoidCallback onBegin;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: MeloCard(
          style: MeloCardStyle.hero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MeloBadge(
                    label: '${session.durationMinutes} min · ${session.category.displayName}',
                    variant: MeloBadgeVariant.primary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                    onPressed: onCancel,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                session.title,
                style: AppTypography.heading1,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                session.description,
                style: AppTypography.body,
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceHighlight.withOpacity(0.5)
                      : AppColors.secondarySurface,
                  borderRadius: AppSpacing.roundedSmall,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chair_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Sit somewhere comfortable and soften your gaze.',
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              MeloButton(
                label: 'Begin reset',
                icon: Icons.play_arrow_rounded,
                isFullWidth: true,
                onPressed: onBegin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
