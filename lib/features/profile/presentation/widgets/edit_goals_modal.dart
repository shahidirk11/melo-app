import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_chip.dart';
import '../../../../shared/widgets/melo_icon_button.dart';

class EditGoalsModal extends StatefulWidget {
  const EditGoalsModal({
    super.key,
    required this.initialGoals,
    required this.onSave,
  });

  final List<String> initialGoals;
  final ValueChanged<List<String>> onSave;

  @override
  State<EditGoalsModal> createState() => _EditGoalsModalState();
}

class _EditGoalsModalState extends State<EditGoalsModal> {
  late Set<String> _selectedGoals;

  static const List<String> availableGoals = [
    'Feel calmer',
    'Reduce everyday stress',
    'Improve focus',
    'Sleep better',
    'Build a mindfulness habit',
    'Take mindful breaks',
    'Just explore',
  ];

  @override
  void initState() {
    super.initState();
    _selectedGoals = Set<String>.from(widget.initialGoals);
  }

  void _save() {
    widget.onSave(_selectedGoals.toList());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Mindful Goals', style: AppTypography.heading2),
              MeloIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Select the intentions that matter most to you. Melo uses these to suggest gentle, relevant practices.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: availableGoals.map((goal) {
              final isSelected = _selectedGoals.contains(goal);
              return MeloChip(
                label: goal,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      if (_selectedGoals.length > 1) {
                        _selectedGoals.remove(goal);
                      }
                    } else {
                      _selectedGoals.add(goal);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          MeloButton(
            label: 'Save Goals',
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
