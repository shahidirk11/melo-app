import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../widgets/onboarding_selection_card.dart';

class DurationStep extends StatefulWidget {
  const DurationStep({
    super.key,
    required this.initialDurationSeconds,
    required this.onContinue,
  });

  final int initialDurationSeconds;
  final ValueChanged<int> onContinue;

  @override
  State<DurationStep> createState() => _DurationStepState();
}

class _DurationStepState extends State<DurationStep> {
  late int _selectedDuration;

  static const List<({String title, String subtitle, int seconds, IconData icon})>
      _durationOptions = [
    (
      title: '1–3 minutes',
      subtitle: 'A single conscious breath or rapid mental reset',
      seconds: 180,
      icon: Icons.flash_on_outlined,
    ),
    (
      title: '5 minutes',
      subtitle: 'Our recommended sweet spot for daily peace',
      seconds: 300,
      icon: Icons.timer_outlined,
    ),
    (
      title: '10 minutes',
      subtitle: 'A deeper unwinding for mind and body',
      seconds: 600,
      icon: Icons.hourglass_empty_rounded,
    ),
    (
      title: '15+ minutes',
      subtitle: 'Extended stillness, body scans, and sleep journeys',
      seconds: 900,
      icon: Icons.self_improvement_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDurationSeconds > 0
        ? widget.initialDurationSeconds
        : 300;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            'How much time do you usually have?',
            style: AppTypography.heading1.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Start small. Even one quiet minute can shift your whole afternoon.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.separated(
              itemCount: _durationOptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final opt = _durationOptions[index];
                final isSelected = _selectedDuration == opt.seconds;
                return OnboardingSelectionCard(
                  title: opt.title,
                  subtitle: opt.subtitle,
                  icon: opt.icon,
                  isSelected: isSelected,
                  isMultiSelect: false,
                  onTap: () {
                    setState(() => _selectedDuration = opt.seconds);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MeloButton(
            label: 'Continue',
            isFullWidth: true,
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              widget.onContinue(_selectedDuration);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
