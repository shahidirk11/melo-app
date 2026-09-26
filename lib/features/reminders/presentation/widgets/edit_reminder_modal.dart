import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../data/models/reminder_model.dart';
import '../../../../shared/widgets/melo_button.dart';
import '../../../../shared/widgets/melo_chip.dart';
import '../../../../shared/widgets/melo_icon_button.dart';
import '../../../../shared/widgets/melo_section_header.dart';

class EditReminderModal extends StatefulWidget {
  const EditReminderModal({
    super.key,
    required this.reminder,
    required this.onSaveTime,
    required this.onSaveDays,
    this.onDelete,
  });

  final ReminderSchedule reminder;
  final void Function(int hour, int minute) onSaveTime;
  final void Function(List<int> days) onSaveDays;
  final VoidCallback? onDelete;

  @override
  State<EditReminderModal> createState() => _EditReminderModalState();
}

class _EditReminderModalState extends State<EditReminderModal> {
  late int _hour;
  late int _minute;
  late Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _hour = widget.reminder.hour;
    _minute = widget.reminder.minute;
    _selectedDays = Set<int>.from(widget.reminder.daysOfWeek);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _hour = picked.hour;
        _minute = picked.minute;
      });
    }
  }

  void _save() {
    widget.onSaveTime(_hour, _minute);
    widget.onSaveDays(_selectedDays.toList()..sort());
    Navigator.of(context).pop();
  }

  String get _formattedPickedTime {
    final period = _hour >= 12 ? 'PM' : 'AM';
    final displayHour = _hour > 12 ? _hour - 12 : (_hour == 0 ? 12 : _hour);
    final displayMinute = _minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const dayLabels = [
      (1, 'M'),
      (2, 'T'),
      (3, 'W'),
      (4, 'T'),
      (5, 'F'),
      (6, 'S'),
      (7, 'S'),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.reminder.slot.title, style: AppTypography.heading2),
              MeloIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Time Picker Container
          InkWell(
            onTap: _pickTime,
            borderRadius: AppSpacing.roundedMedium,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceHighlight
                    : AppColors.secondarySurface,
                borderRadius: AppSpacing.roundedMedium,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reminder Time', style: AppTypography.caption),
                      const SizedBox(height: 2),
                      Text(
                        _formattedPickedTime,
                        style: AppTypography.heading1.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Day Selection Presets
          const MeloSectionHeader(title: 'Days of the Week'),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              MeloChip(
                label: 'Every day',
                isSelected: _selectedDays.length == 7,
                onTap: () {
                  setState(() => _selectedDays = {1, 2, 3, 4, 5, 6, 7});
                },
              ),
              MeloChip(
                label: 'Weekdays',
                isSelected: _selectedDays.length == 5 &&
                    _selectedDays.containsAll([1, 2, 3, 4, 5]),
                onTap: () {
                  setState(() => _selectedDays = {1, 2, 3, 4, 5});
                },
              ),
              MeloChip(
                label: 'Weekends',
                isSelected: _selectedDays.length == 2 &&
                    _selectedDays.containsAll([6, 7]),
                onTap: () {
                  setState(() => _selectedDays = {6, 7});
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Individual Day Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dayLabels.map((d) {
              final dayNum = d.$1;
              final dayLetter = d.$2;
              final isSelected = _selectedDays.contains(dayNum);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      if (_selectedDays.length > 1) {
                        _selectedDays.remove(dayNum);
                      }
                    } else {
                      _selectedDays.add(dayNum);
                    }
                  });
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.darkSurfaceHighlight
                            : AppColors.secondarySurface),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      dayLetter,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.darkText : AppColors.deepText),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Notification Preview
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceHighlight
                  : AppColors.secondarySurface,
              borderRadius: AppSpacing.roundedMedium,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reminder.notificationTitle,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.reminder.notificationBody,
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkMutedText : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          MeloButton(
            label: 'Save Changes',
            isFullWidth: true,
            variant: MeloButtonVariant.primary,
            onPressed: _save,
          ),
          if (widget.onDelete != null) ...[
            const SizedBox(height: AppSpacing.xs),
            MeloButton(
              label: 'Delete Reminder',
              isFullWidth: true,
              variant: MeloButtonVariant.ghost,
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete!();
              },
            ),
          ],
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
