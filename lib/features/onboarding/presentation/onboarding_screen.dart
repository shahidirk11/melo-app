import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/app_config.dart';
import '../../../app/providers.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/models/user_preferences_model.dart';
import '../../../shared/widgets/melo_icon_button.dart';
import '../../../shared/widgets/melo_progress_indicator.dart';
import '../../../shared/widgets/melo_responsive_container.dart';
import 'steps/duration_step.dart';
import 'steps/first_session_step.dart';
import 'steps/goals_step.dart';
import 'steps/reminder_permission_step.dart';
import 'steps/reminder_time_step.dart';
import 'steps/welcome_step.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 6;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _completeOnboardingAndNavigate(String destinationRoute) async {
    final notifier = ref.read(userPreferencesProvider.notifier);
    await notifier.setOnboardingCompleted(true);
    if (mounted) {
      context.go(destinationRoute);
    }
  }

  String _formatTime(TimeOfDayPreference pref, int hour, int minute) {
    if (pref == TimeOfDayPreference.morning) return '8:00 AM';
    if (pref == TimeOfDayPreference.afternoon) return '1:00 PM';
    if (pref == TimeOfDayPreference.evening) return '8:00 PM';
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final prefs = ref.watch(userPreferencesProvider);
    final notifier = ref.read(userPreferencesProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final progressRatio = (_currentStep) / (_totalSteps - 1);
    final formattedTime = _formatTime(
      prefs.preferredTimeOfDay,
      prefs.customReminderHour,
      prefs.customReminderMinute,
    );

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _currentStep > 0) {
          _previousPage();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: MeloResponsiveContainer(
            child: Column(
              children: [
                // Top Header: Back Button & Step Progress Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          MeloIconButton(
                            icon: Icons.arrow_back_rounded,
                            tooltip: 'Back to previous step',
                            variant: MeloIconButtonVariant.standard,
                            onPressed: _previousPage,
                          )
                        else
                          const SizedBox(width: AppSpacing.iconButtonSize),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: MeloLinearProgressIndicator(
                            progress: progressRatio,
                            height: 4.0,
                            progressColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          '${_currentStep + 1}/$_totalSteps',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Step Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(), // Controlled transition
                    onPageChanged: (page) => setState(() => _currentStep = page),
                    children: [
                      // Step 1: Welcome
                      WelcomeStep(
                        config: config,
                        onNext: _nextPage,
                      ),

                      // Step 2: Goals (Multi-select)
                      GoalsStep(
                        initialGoals: prefs.goals,
                        onContinue: (goals) async {
                          await notifier.setGoals(goals);
                          _nextPage();
                        },
                      ),

                      // Step 3: Preferred Duration
                      DurationStep(
                        initialDurationSeconds: prefs.preferredDurationSeconds,
                        onContinue: (durationSeconds) async {
                          await notifier.setPreferredDuration(durationSeconds);
                          _nextPage();
                        },
                      ),

                      // Step 4: Preferred Reset Time
                      ReminderTimeStep(
                        initialTimeOfDay: prefs.preferredTimeOfDay,
                        initialCustomHour: prefs.customReminderHour,
                        initialCustomMinute: prefs.customReminderMinute,
                        onContinue: (timeOfDay, hour, minute) async {
                          await notifier.setPreferredTimeOfDay(
                            timeOfDay,
                            customHour: hour,
                            customMinute: minute,
                          );
                          _nextPage();
                        },
                      ),

                      // Step 5: Notification Permission Context
                      ReminderPermissionStep(
                        formattedTime: formattedTime,
                        onDecision: (enabled) async {
                          await notifier.setNotificationsEnabled(enabled);
                          _nextPage();
                        },
                      ),

                      // Step 6: First-Session Invitation
                      FirstSessionStep(
                        onStartFirstSession: () {
                          _completeOnboardingAndNavigate(
                            AppRoutes.sessionPath('session_1m_reset'),
                          );
                        },
                        onSkipToHome: () {
                          _completeOnboardingAndNavigate(AppRoutes.home);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
