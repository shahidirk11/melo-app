import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/session_model.dart';
import '../../../../shared/widgets/melo_chip.dart';

class CategoryPillsBar extends StatelessWidget {
  const CategoryPillsBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final SessionCategory? selectedCategory;
  final ValueChanged<SessionCategory?> onCategorySelected;

  static IconData getCategoryIcon(SessionCategory category) {
    switch (category) {
      case SessionCategory.calm:
        return Icons.spa_outlined;
      case SessionCategory.focus:
        return Icons.track_changes_outlined;
      case SessionCategory.sleep:
        return Icons.bedtime_outlined;
      case SessionCategory.morning:
        return Icons.wb_sunny_outlined;
      case SessionCategory.breathing:
        return Icons.air_outlined;
      case SessionCategory.beginner:
        return Icons.eco_outlined;
      case SessionCategory.stressReset:
        return Icons.healing_outlined;
      case SessionCategory.relaxation:
        return Icons.self_improvement_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          MeloChip(
            label: 'All',
            icon: Icons.grid_view_rounded,
            isSelected: selectedCategory == null,
            onTap: () => onCategorySelected(null),
          ),
          ...SessionCategory.values.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: MeloChip(
                label: cat.displayName,
                icon: getCategoryIcon(cat),
                isSelected: selectedCategory == cat,
                onTap: () {
                  if (selectedCategory == cat) {
                    onCategorySelected(null);
                  } else {
                    onCategorySelected(cat);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
