import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/text_styles.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final double height;
  final Color foregroundColor;
  final Color backgroundColor;
  final double radius;
  final TextStyle textStyle;
  final EdgeInsets? padding;
  const CustomOutlinedButton({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    this.height = AppConstants.btnSize,
    this.backgroundColor = AppColors.transparent,
    this.foregroundColor = AppColors.secondary,
    this.radius = AppConstants.borderRadius,
    this.textStyle = TextStyles.medium14,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => onTap.call(),
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        visualDensity: VisualDensity.compact,
        fixedSize: Size.fromHeight(height),
        padding: padding,
        side: BorderSide(
          color: foregroundColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        textStyle: textStyle,
      ),
      icon: icon != null ? Icon(icon) : null,
      label: Text(
        title,
      ),
    );
  }
}
