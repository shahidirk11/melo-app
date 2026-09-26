import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/models/session_model.dart';
import '../../../shared/animations/melo_slide_transition.dart';
import '../../../shared/widgets/melo_bottom_sheet.dart';
import '../../../shared/widgets/melo_chip.dart';
import '../../../shared/widgets/melo_responsive_container.dart';
import '../../../shared/widgets/melo_snackbar.dart';
import '../../../shared/widgets/state_views/empty_view.dart';
import '../../../shared/widgets/state_views/error_view.dart';
import '../../../shared/widgets/state_views/loading_view.dart';
import '../domain/explore_filter.dart';
import 'explore_provider.dart';
import 'widgets/category_pills_bar.dart';
import 'widgets/explore_filter_sheet.dart';
import 'widgets/explore_search_bar.dart';
import 'widgets/explore_session_card.dart';
import 'widgets/session_details_modal.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(ExploreViewState state) {
    MeloBottomSheet.show(
      context,
      child: ExploreFilterSheet(
        initialFilter: state.filter,
        onApply: (newFilter) {
          ref.read(exploreNotifierProvider.notifier).applyFilter(newFilter);
        },
      ),
    );
  }

  void _openSessionDetails(Session session, bool isFavorite) {
    MeloBottomSheet.show(
      context,
      child: SessionDetailsModal(
        session: session,
        isFavorite: isFavorite,
        onToggleFavorite: () {
          ref.read(exploreNotifierProvider.notifier).toggleFavorite(session.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exploreNotifierProvider);
    final notifier = ref.read(exploreNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sync search controller if filter was reset externally
    if (state.filter.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
      _searchController.clear();
    }

    return Scaffold(
      body: SafeArea(
        child: MeloResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Screen Header & Search Bar
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  top: AppSpacing.md,
                  bottom: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MeloSlideTransition(
                      delay: const Duration(milliseconds: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Explore', style: AppTypography.display),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Mindful practices for every part of your day',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    MeloSlideTransition(
                      delay: const Duration(milliseconds: 100),
                      child: ExploreSearchBar(
                        controller: _searchController,
                        activeFilterCount: state.filter.activeFiltersCount,
                        onChanged: (val) => notifier.setSearchQuery(val),
                        onClear: () => notifier.setSearchQuery(''),
                        onFilterTap: () => _openFilterSheet(state),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Categories Pills Bar
              MeloSlideTransition(
                delay: const Duration(milliseconds: 150),
                child: CategoryPillsBar(
                  selectedCategory: state.filter.category,
                  onCategorySelected: (cat) => notifier.setCategory(cat),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // 3. Quick Filter Chips Bar (Durations & Favorites)
              MeloSlideTransition(
                delay: const Duration(milliseconds: 180),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      // Favorites Toggle Chip
                      MeloChip(
                        label: 'Favorites',
                        icon: state.filter.onlyFavorites
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        isSelected: state.filter.onlyFavorites,
                        onTap: () => notifier.toggleOnlyFavorites(),
                      ),
                      const SizedBox(width: AppSpacing.xs),

                      // Duration Filters
                      ...ExploreDurationFilter.values
                          .where((d) => d != ExploreDurationFilter.all)
                          .map((d) {
                        final isSelected = state.filter.duration == d;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: MeloChip(
                            label: d.label,
                            isSelected: isSelected,
                            onTap: () {
                              notifier.setDuration(
                                isSelected ? ExploreDurationFilter.all : d,
                              );
                            },
                          ),
                        );
                      }),

                      // Clear All Filters (if active)
                      if (state.filter.hasActiveFilters)
                        ActionChip(
                          avatar: const Icon(Icons.clear_all_rounded, size: 16),
                          label: Text(
                            'Clear filters',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          backgroundColor: isDark
                              ? AppColors.darkSurfaceHighlight
                              : AppColors.secondarySurface,
                          side: BorderSide.none,
                          onPressed: () {
                            _searchController.clear();
                            notifier.clearFilters();
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // 4. Results Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.isLoading
                          ? 'Finding practices...'
                          : '${state.filteredSessions.length} ${state.filteredSessions.length == 1 ? 'practice' : 'practices'}',
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (state.filter.hasActiveFilters)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          notifier.clearFilters();
                        },
                        child: Text(
                          'Reset',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // 5. Session List / Empty States / Loading States
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading) {
                      return const LoadingView(
                        message: 'Loading mindful practices...',
                      );
                    }

                    if (state.errorMessage != null) {
                      return ErrorView(
                        title: 'Unable to load practices',
                        message: state.errorMessage!,
                        retryLabel: 'Try again',
                        onRetry: () => notifier.load(),
                      );
                    }

                    if (state.filteredSessions.isEmpty) {
                      if (state.filter.onlyFavorites) {
                        return EmptyView(
                          title: 'No saved favorites yet',
                          message:
                              'Tap the bookmark icon on any practice to save it here for quick access.',
                          icon: Icons.bookmark_border_rounded,
                          actionLabel: 'Browse all practices',
                          onAction: () => notifier.setOnlyFavorites(false),
                        );
                      }

                      return EmptyView(
                        title: 'No practices found',
                        message:
                            'We couldn\'t find any practices matching your current search or filters.',
                        icon: Icons.search_off_rounded,
                        actionLabel: 'Clear all filters',
                        onAction: () {
                          _searchController.clear();
                          notifier.clearFilters();
                        },
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xs,
                      ),
                      cacheExtent: 400.0,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: state.filteredSessions.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final session = state.filteredSessions[index];
                        final isFav = state.isFavorite(session.id);

                        return ExploreSessionCard(
                          key: ValueKey('explore_session_${session.id}'),
                          session: session,
                          isFavorite: isFav,
                          onTap: () => _openSessionDetails(session, isFav),
                          onPlay: () {
                            context.push(AppRoutes.sessionPath(session.id));
                          },
                          onToggleFavorite: () async {
                            await notifier.toggleFavorite(session.id);
                            if (mounted) {
                              MeloSnackbar.show(
                                context,
                                message: isFav
                                    ? 'Removed from favorites'
                                    : 'Saved to favorites',
                                type: MeloSnackbarType.info,
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
