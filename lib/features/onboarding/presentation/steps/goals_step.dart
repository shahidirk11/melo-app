import 'package:flutter/material.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../widgets/onboarding_selection_card.dart';

class GoalsStep extends StatefulWidget {
  const GoalsStep({
    super.key,
    required this.initialGoals,
    required this.onContinue,
  });

  final List<String> initialGoals;
  final ValueChanged<List<String>> onContinue;

  @override
  State<GoalsStep> createState() => _GoalsStepState();
}

class _GoalsStepState extends State<GoalsStep> {
  late final Set<String> _selectedGoals;

  static const List<({String title, String subtitle, IconData icon})> _goalOptions = [
    (
      title: 'Feel calmer',
      subtitle: 'Soothe nervous tension throughout your day',
      icon: Icons.spa_outlined,
    ),
    (
      title: 'Reduce everyday stress',
      subtitle: 'Gentle pauses when demands get overwhelming',
      icon: Icons.wb_twilight_rounded,
    ),
    (
      title: 'Improve focus',
      subtitle: 'Anchor attention and clear lingering mental fog',
      icon: Icons.filter_center_focus_rounded,
    ),
    (
      title: 'Sleep better',
      subtitle: 'Ease into quiet evenings with wind-down routines',
      icon: Icons.bedtime_outlined,
    ),
    (
      title: 'Build a mindfulness habit',
      subtitle: 'Show up for yourself consistently in small ways',
      icon: Icons.favorite_outline_rounded,
    ),
    (
      title: 'Take mindful breaks',
      subtitle: 'Quick 1- to 3-minute breathers between tasks',
      icon: Icons.timer_outlined,
    ),
    (
      title: 'Just explore',
      subtitle: 'No specific pressure, just curious about quiet moments',
      icon: Icons.explore_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedGoals = Set.from(
      widget.initialGoals.isNotEmpty ? widget.initialGoals : ['Feel calmer'],
    );
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        if (_selectedGoals.length > 1) {
          _selectedGoals.remove(goal);
        }
      } else {
        _selectedGoals.add(goal);
      }
    });
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
            'What would you like help with?',
            style: AppTypography.heading1.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Select all that resonate. We\'ll tailor your daily recommendations.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.separated(
              itemCount: _goalOptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final opt = _goalOptions[index];
                final isSelected = _selectedGoals.contains(opt.title);
                return OnboardingSelectionCard(
                  title: opt.title,
                  subtitle: opt.subtitle,
                  icon: opt.icon,
                  isSelected: isSelected,
                  isMultiSelect: true,
                  onTap: () => _toggleGoal(opt.title),
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
              widget.onContinue(_selectedGoals.toList());
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
