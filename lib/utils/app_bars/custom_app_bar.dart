import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/text_styles.dart';
import '../buttons/custom_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? action;
  final String title;
  final Color? navBarColor;
  final Color? statusBarColor;
  final Brightness? androidStatusBarBrightness;
  final Brightness? iosStatusBarBrightness;
  final double height;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  const CustomAppBar({
    super.key,
    this.leading,
    this.action,
    required this.title,
    this.navBarColor,
    this.statusBarColor,
    this.androidStatusBarBrightness,
    this.iosStatusBarBrightness,
    this.height = kToolbarHeight,
    this.textStyle = TextStyles.bold18,
    this.backgroundColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ?? const _BackButton(),
      actions: [action ?? const SizedBox()],
      title: Text(title, style: textStyle?.copyWith(color: AppColors.white)),
      backgroundColor: backgroundColor,
      systemOverlayStyle: AppConstants.systemOverlay.copyWith(
        statusBarColor: statusBarColor,
        systemNavigationBarColor: navBarColor,
        statusBarBrightness: iosStatusBarBrightness,
        statusBarIconBrightness: androidStatusBarBrightness,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppConstants.screenPadding * .8),
      child: Align(
        child: CustomIconButton(
          onTap: () => _goBack(context),
          icon: Icons.arrow_back_ios_new,
          color: AppColors.white,
          iconSize: AppConstants.mediumIconSize,
        ),
      ),
    );
  }

  void _goBack(context) {
    Navigator.of(context).maybePop();
  }
}
