import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../../constants/text_styles.dart';
import '../loader/custom_circular_loader.dart';

class CustomFilledButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final Color borderColor;
  final double radius;
  final IconData? icon;
  final IconData? trailingIcon;
  final double borderWidth;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  const CustomFilledButton({
    super.key,
    required this.title,
    required this.onTap,
    this.height = AppConstants.btnSize,
    this.backgroundColor = AppColors.secondary,
    this.foregroundColor = AppColors.white,
    this.textStyle = TextStyles.semi16,
    this.borderColor = AppColors.transparent,
    this.radius = 16,
    this.icon,
    this.borderWidth = 1.0,
    this.elevation = 0,
    this.padding,
    this.isLoading = false,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: CustomCircularLoader(size: height - (5 * 2)),
      );
    }
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        fixedSize: Size.fromHeight(height),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: textStyle,
        padding: padding,
        elevation: elevation,
        minimumSize: Size(64, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
      onPressed: onTap,
      icon: icon != null ? _Icon(icon: icon) : null,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyles.bold16.copyWith(color: AppColors.white),
          ),
          if (trailingIcon != null) ...[
            AppSpaces.smallWidth,
            _Icon(icon: trailingIcon),
          ],
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final IconData? icon;
  const _Icon({required this.icon});

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return const SizedBox.shrink();
    }
    return Icon(icon, size: AppConstants.smallIconSize);
  }
}
