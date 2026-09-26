import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/session_model.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_chip.dart';
import '../../../../shared/widgets/melo_section_header.dart';
import '../../domain/explore_filter.dart';

class ExploreFilterSheet extends StatefulWidget {
  const ExploreFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  final ExploreFilter initialFilter;
  final ValueChanged<ExploreFilter> onApply;

  @override
  State<ExploreFilterSheet> createState() => _ExploreFilterSheetState();
}

class _ExploreFilterSheetState extends State<ExploreFilterSheet> {
  late SessionCategory? _selectedCategory;
  late ExploreDurationFilter _selectedDuration;
  late SessionDifficulty? _selectedDifficulty;
  late bool _onlyFavorites;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialFilter.category;
    _selectedDuration = widget.initialFilter.duration;
    _selectedDifficulty = widget.initialFilter.difficulty;
    _onlyFavorites = widget.initialFilter.onlyFavorites;
  }

  void _reset() {
    setState(() {
      _selectedCategory = null;
      _selectedDuration = ExploreDurationFilter.all;
      _selectedDifficulty = null;
      _onlyFavorites = false;
    });
  }

  void _apply() {
    final updated = widget.initialFilter.copyWith(
      category: () => _selectedCategory,
      duration: _selectedDuration,
      difficulty: () => _selectedDifficulty,
      onlyFavorites: _onlyFavorites,
    );
    widget.onApply(updated);
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
              Text(
                'Filter Practices',
                style: AppTypography.heading2.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                ),
              ),
              TextButton(
                onPressed: _reset,
                child: Text(
                  'Reset all',
                  style: AppTypography.labelLarge.copyWith(
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 1. Favorites Filter Toggle
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceHighlight
                  : AppColors.secondarySurface,
              borderRadius: AppSpacing.roundedMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _onlyFavorites
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: _onlyFavorites
                          ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                          : (isDark ? AppColors.darkMutedText : AppColors.mutedText),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Show favorites only',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                      ),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: _onlyFavorites,
                  activeColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                  onChanged: (val) => setState(() => _onlyFavorites = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 2. Duration Filter
          const MeloSectionHeader(title: 'Duration'),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: ExploreDurationFilter.values.map((d) {
              return MeloChip(
                label: d.label,
                isSelected: _selectedDuration == d,
                onTap: () => setState(() => _selectedDuration = d),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 3. Category Filter
          const MeloSectionHeader(title: 'Category'),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              MeloChip(
                label: 'All Categories',
                isSelected: _selectedCategory == null,
                onTap: () => setState(() => _selectedCategory = null),
              ),
              ...SessionCategory.values.map((cat) {
                return MeloChip(
                  label: cat.displayName,
                  isSelected: _selectedCategory == cat,
                  onTap: () => setState(() => _selectedCategory = cat),
                );
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 4. Difficulty Filter
          const MeloSectionHeader(title: 'Difficulty'),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              MeloChip(
                label: 'All Levels',
                isSelected: _selectedDifficulty == null,
                onTap: () => setState(() => _selectedDifficulty = null),
              ),
              ...SessionDifficulty.values.map((diff) {
                return MeloChip(
                  label: diff.displayName,
                  isSelected: _selectedDifficulty == diff,
                  onTap: () => setState(() => _selectedDifficulty = diff),
                );
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Apply button
          MeloButton(
            label: 'Apply Filters',
            variant: MeloButtonVariant.primary,
            isFullWidth: true,
            onPressed: _apply,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
