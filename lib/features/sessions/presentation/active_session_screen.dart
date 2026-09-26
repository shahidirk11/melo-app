import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/animations/melo_fade_scale.dart';
import '../../../shared/widgets/melo_badge.dart';
import '../../../shared/widgets/melo_dialog.dart';
import '../../../shared/widgets/melo_icon_button.dart';
import '../../../shared/widgets/melo_progress_indicator.dart';
import '../../../shared/widgets/melo_responsive_container.dart';
import '../../../shared/widgets/state_views/error_view.dart';
import '../../../shared/widgets/state_views/loading_view.dart';
import '../domain/session_state.dart';
import 'session_provider.dart';
import 'widgets/breathing_circle_visualizer.dart';
import 'widgets/session_intro_dialog.dart';

class ActiveSessionScreen extends ConsumerStatefulWidget {
  const ActiveSessionScreen({
    super.key,
    required this.sessionId,
  });

  final String sessionId;

  @override
  ConsumerState<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen>
    with WidgetsBindingObserver {
  bool _showIntro = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionEngineProvider.notifier).initSession(widget.sessionId);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      final allowBg = ref.read(appSettingsProvider).backgroundAudioEnabled;
      if (!allowBg) {
        ref.read(sessionEngineProvider.notifier).pause();
      }
    }
  }

  Future<bool> _confirmLeave() async {
    final leave = await MeloDialog.show(
      context: context,
      title: 'Leave session?',
      content: 'You\'ll lose this session\'s current progress.',
      primaryActionLabel: 'Leave',
      secondaryActionLabel: 'Continue',
      isDestructive: true,
    );
    return leave ?? false;
  }

  Future<void> _handleExit() async {
    final shouldLeave = await _confirmLeave();
    if (shouldLeave && mounted) {
      await ref.read(sessionEngineProvider.notifier).finish(wasCompleted: false);
      if (mounted) {
        context.pop();
      }
    }
  }

  void _onCompleteSession() {
    ref.read(sessionEngineProvider.notifier).finish(wasCompleted: true);
    context.go(AppRoutes.sessionCompletePath(widget.sessionId));
  }

  void _showVolumeSheet(BuildContext context, SessionEngineNotifier notifier, double currentVolume) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        double vol = currentVolume;
        return StatefulBuilder(
          builder: (modalCtx, setModalState) => Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.cardSurface,
              borderRadius: AppSpacing.roundedSheet,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Audio Volume', style: AppTypography.heading3),
                    MeloIconButton(
                      icon: Icons.close_rounded,
                      size: 20,
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(Icons.volume_down_rounded, color: AppColors.primary),
                    Expanded(
                      child: Slider(
                        value: vol,
                        min: 0.0,
                        max: 1.0,
                        activeColor: AppColors.primary,
                        onChanged: (newVol) {
                          setModalState(() => vol = newVol);
                          notifier.setVolume(newVol);
                        },
                      ),
                    ),
                    const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final playback = ref.watch(sessionEngineProvider);
    final notifier = ref.read(sessionEngineProvider.notifier);
    final prefs = ref.watch(userPreferencesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for automatic session completion
    ref.listen<SessionPlaybackState>(sessionEngineProvider, (prev, next) {
      if (next.state == SessionState.completed && mounted) {
        context.go(AppRoutes.sessionCompletePath(widget.sessionId));
      }
    });

    if (playback.state == SessionState.preparing) {
      return const Scaffold(
        body: LoadingView(message: 'Preparing your space...'),
      );
    }

    if (playback.state == SessionState.error) {
      return Scaffold(
        body: ErrorView(
          title: 'Unable to open session',
          message: playback.errorMessage ?? 'Something went wrong.',
          retryLabel: 'Go back',
          onRetry: () => context.pop(),
        ),
      );
    }

    final session = playback.session;
    if (session == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    // Pre-session Intro Modal
    if (_showIntro) {
      return Scaffold(
        body: SafeArea(
          child: MeloResponsiveContainer(
            child: SessionIntroDialog(
              session: session,
              onBegin: () {
                setState(() => _showIntro = false);
                notifier.start();
              },
              onCancel: () => context.pop(),
            ),
          ),
        ),
      );
    }

    final remMins = (playback.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final remSecs = (playback.remainingSeconds % 60).toString().padLeft(2, '0');
    final formattedRemaining = '$remMins:$remSecs';

    final audioLabel = playback.hasNarration && playback.hasAmbient
        ? 'Guided & Ambient'
        : (playback.hasNarration
            ? 'Guided Voice'
            : (playback.hasAmbient ? 'Ambient Sound' : 'Text Guidance'));

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _handleExit();
      },
      child: Scaffold(
        body: SafeArea(
          child: MeloResponsiveContainer(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  // 1. Top Bar: Exit button, category / audio badge, and audio mute/volume toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MeloIconButton(
                        icon: Icons.close_rounded,
                        tooltip: 'Leave session',
                        variant: MeloIconButtonVariant.surface,
                        onPressed: _handleExit,
                      ),
                      Column(
                        children: [
                          Text(
                            session.category.displayName.toUpperCase(),
                            style: AppTypography.caption.copyWith(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          MeloBadge(
                            label: audioLabel,
                            variant: playback.isFallbackMode
                                ? MeloBadgeVariant.neutral
                                : MeloBadgeVariant.primary,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MeloIconButton(
                            icon: Icons.tune_rounded,
                            tooltip: 'Volume adjustment',
                            variant: MeloIconButtonVariant.surface,
                            onPressed: () => _showVolumeSheet(context, notifier, playback.volume),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          MeloIconButton(
                            icon: playback.isMuted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            tooltip: playback.isMuted ? 'Unmute' : 'Mute',
                            variant: MeloIconButtonVariant.surface,
                            onPressed: notifier.toggleMute,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Linear Progress Bar & Interactive Scrubber
                  const SizedBox(height: AppSpacing.md),
                  MeloLinearProgressIndicator(
                    progress: playback.progress,
                    height: 4.0,
                  ),
                  const Spacer(),

                  // 2. Breathing / Presence Visualizer
                  BreathingCircleVisualizer(
                    phase: playback.breathingPhase,
                    remainingFormatted: formattedRemaining,
                    isReducedMotion: prefs.reducedMotion,
                    isPlaying: playback.isPlaying,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 3. Guidance Text & Subtext
                  MeloFadeScale(
                    key: ValueKey(playback.currentInstruction),
                    duration: const Duration(milliseconds: 280),
                    child: Column(
                      children: [
                        Text(
                          playback.currentInstruction,
                          style: AppTypography.heading2.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (playback.currentSubtext != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            playback.currentSubtext!,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),

                  // 4. Scrubbing slider for seeking
                  if (playback.totalSeconds > 0) ...[
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                        activeTrackColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                        inactiveTrackColor: isDark ? AppColors.darkBorder : AppColors.subtleBorder,
                        thumbColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                      ),
                      child: Slider(
                        value: playback.elapsedSeconds.toDouble().clamp(0.0, playback.totalSeconds.toDouble()),
                        min: 0.0,
                        max: playback.totalSeconds.toDouble(),
                        onChanged: (val) {
                          notifier.seek(val.round());
                        },
                      ),
                    ),
                  ],

                  // 5. Playback Controls (Rewind 10s, Play/Pause, Forward 10s, Finish Early)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Rewind 10s button
                      MeloIconButton(
                        icon: Icons.replay_10_rounded,
                        tooltip: 'Rewind 10 seconds',
                        size: 44,
                        iconSize: 22,
                        variant: MeloIconButtonVariant.surface,
                        onPressed: () => notifier.seek(playback.elapsedSeconds - 10),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Restart button
                      MeloIconButton(
                        icon: Icons.replay_rounded,
                        tooltip: 'Restart session',
                        size: 44,
                        iconSize: 22,
                        variant: MeloIconButtonVariant.surface,
                        onPressed: notifier.restart,
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Large Play/Pause button
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 36,
                          icon: Icon(
                            playback.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: isDark
                                ? AppColors.darkBackground
                                : Colors.white,
                          ),
                          tooltip: playback.isPlaying ? 'Pause' : 'Resume',
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            if (playback.isPlaying) {
                              notifier.pause();
                            } else {
                              notifier.resume();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Forward 10s button
                      MeloIconButton(
                        icon: Icons.forward_10_rounded,
                        tooltip: 'Skip 10 seconds',
                        size: 44,
                        iconSize: 22,
                        variant: MeloIconButtonVariant.surface,
                        onPressed: () => notifier.seek(playback.elapsedSeconds + 10),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Finish early button
                      MeloIconButton(
                        icon: Icons.check_rounded,
                        tooltip: 'Complete session early',
                        size: 44,
                        iconSize: 22,
                        variant: MeloIconButtonVariant.surface,
                        onPressed: _onCompleteSession,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
