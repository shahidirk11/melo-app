import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import 'melo_icon_button.dart';

class MeloAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MeloAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: AppTypography.heading2.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepText,
              ),
            )
          : null,
      leading: leading ??
          (canPop
              ? Center(
                  child: MeloIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    variant: MeloIconButtonVariant.standard,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                )
              : null),
      actions: actions,
      bottom: bottom,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
