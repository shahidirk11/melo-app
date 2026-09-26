import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_chip.dart';
import '../../../../shared/widgets/melo_icon_button.dart';

class EditDurationModal extends StatefulWidget {
  const EditDurationModal({
    super.key,
    required this.initialDurationSeconds,
    required this.onSave,
  });

  final int initialDurationSeconds;
  final ValueChanged<int> onSave;

  @override
  State<EditDurationModal> createState() => _EditDurationModalState();
}

class _EditDurationModalState extends State<EditDurationModal> {
  late int _selectedSeconds;

  static const List<(int, String, String)> durationOptions = [
    (180, '1–3 min', 'Quick, micro-pauses between tasks'),
    (300, '5 min', 'A gentle balance of breath and presence'),
    (600, '10 min', 'Deeper stillness and body relaxation'),
    (900, '15+ min', 'Extended quiet care and sleep wind-down'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSeconds = widget.initialDurationSeconds;
  }

  void _save() {
    widget.onSave(_selectedSeconds);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Preferred Session Length', style: AppTypography.heading2),
              MeloIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Choose your usual pace. Melo will prioritize recommendations that fit your day.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          ...durationOptions.map((opt) {
            final seconds = opt.$1;
            final label = opt.$2;
            final subtext = opt.$3;
            final isSelected = _selectedSeconds == seconds;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: InkWell(
                onTap: () => setState(() => _selectedSeconds = seconds),
                borderRadius: AppSpacing.roundedMedium,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? AppColors.darkPrimary.withOpacity(0.18)
                            : AppColors.primaryLight.withOpacity(0.25))
                        : (isDark
                            ? AppColors.darkSurfaceHighlight
                            : AppColors.secondarySurface),
                    borderRadius: AppSpacing.roundedMedium,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkMutedText : AppColors.mutedText),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: AppTypography.heading3.copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.darkText : AppColors.deepText),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtext,
                              style: AppTypography.caption.copyWith(
                                color: isDark
                                    ? AppColors.darkMutedText
                                    : AppColors.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          MeloButton(
            label: 'Save Session Length',
            isFullWidth: true,
            variant: MeloButtonVariant.primary,
            onPressed: _save,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
