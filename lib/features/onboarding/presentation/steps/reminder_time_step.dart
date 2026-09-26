import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/user_preferences_model.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_card.dart';
import '../widgets/onboarding_selection_card.dart';

class ReminderTimeStep extends StatefulWidget {
  const ReminderTimeStep({
    super.key,
    required this.initialTimeOfDay,
    required this.initialCustomHour,
    required this.initialCustomMinute,
    required this.onContinue,
  });

  final TimeOfDayPreference initialTimeOfDay;
  final int initialCustomHour;
  final int initialCustomMinute;
  final void Function(TimeOfDayPreference timeOfDay, int hour, int minute) onContinue;

  @override
  State<ReminderTimeStep> createState() => _ReminderTimeStepState();
}

class _ReminderTimeStepState extends State<ReminderTimeStep> {
  late TimeOfDayPreference _selectedTimeOfDay;
  late int _customHour;
  late int _customMinute;

  @override
  void initState() {
    super.initState();
    _selectedTimeOfDay = widget.initialTimeOfDay;
    _customHour = widget.initialCustomHour;
    _customMinute = widget.initialCustomMinute;
  }

  Future<void> _pickCustomTime() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _customHour, minute: _customMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: AppColors.darkPrimary,
                    onPrimary: AppColors.darkBackground,
                    surface: AppColors.darkSurface,
                    onSurface: AppColors.darkTextPrimary,
                  )
                : ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: Theme.of(context).cardColor,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTimeOfDay = TimeOfDayPreference.custom;
        _customHour = picked.hour;
        _customMinute = picked.minute;
      });
    }
  }

  String get _formattedCustomTime {
    final period = _customHour >= 12 ? 'PM' : 'AM';
    final h = _customHour > 12 ? _customHour - 12 : (_customHour == 0 ? 12 : _customHour);
    final m = _customMinute.toString().padLeft(2, '0');
    return '$h:$m $period';
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
            'When would you like your daily reset?',
            style: AppTypography.heading1.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'We\'ll prepare your personalized session for this window.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              children: [
                OnboardingSelectionCard(
                  title: 'Morning',
                  subtitle: '8:00 AM · Ground your day before it starts',
                  icon: Icons.wb_sunny_outlined,
                  isSelected: _selectedTimeOfDay == TimeOfDayPreference.morning,
                  onTap: () {
                    setState(() {
                      _selectedTimeOfDay = TimeOfDayPreference.morning;
                      _customHour = 8;
                      _customMinute = 0;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                OnboardingSelectionCard(
                  title: 'Afternoon',
                  subtitle: '1:00 PM · Take a mindful pause during work',
                  icon: Icons.wb_twilight_outlined,
                  isSelected: _selectedTimeOfDay == TimeOfDayPreference.afternoon,
                  onTap: () {
                    setState(() {
                      _selectedTimeOfDay = TimeOfDayPreference.afternoon;
                      _customHour = 13;
                      _customMinute = 0;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                OnboardingSelectionCard(
                  title: 'Evening',
                  subtitle: '8:00 PM · Unwind and transition into rest',
                  icon: Icons.nights_stay_outlined,
                  isSelected: _selectedTimeOfDay == TimeOfDayPreference.evening,
                  onTap: () {
                    setState(() {
                      _selectedTimeOfDay = TimeOfDayPreference.evening;
                      _customHour = 20;
                      _customMinute = 0;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                OnboardingSelectionCard(
                  title: 'Custom time',
                  subtitle: _selectedTimeOfDay == TimeOfDayPreference.custom
                      ? 'Selected: $_formattedCustomTime'
                      : 'Choose your own quiet window',
                  icon: Icons.schedule_rounded,
                  isSelected: _selectedTimeOfDay == TimeOfDayPreference.custom,
                  onTap: () {
                    setState(() {
                      _selectedTimeOfDay = TimeOfDayPreference.custom;
                    });
                    _pickCustomTime();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MeloButton(
            label: 'Continue',
            isFullWidth: true,
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              widget.onContinue(_selectedTimeOfDay, _customHour, _customMinute);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
