import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/text_styles.dart';
import '../loader/custom_circular_loader.dart';
import 'custom_filled_button.dart';

class ExpandedFilledButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final Color borderColor;
  final double radius;
  final IconData? icon;
  final double borderWidth;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  const ExpandedFilledButton({
    super.key,
    required this.title,
    required this.onTap,
    this.height = AppConstants.btnSize,
    this.backgroundColor = AppColors.secondary,
    this.foregroundColor = AppColors.white,
    this.textStyle = TextStyles.regular18,
    this.borderColor = AppColors.transparent,
    this.radius = 18,
    this.icon,
    this.borderWidth = 1.0,
    this.elevation = 0,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: CustomCircularLoader(
          size: height - (5 * 2),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: CustomFilledButton(
            title: title,
            onTap: onTap,
            borderColor: borderColor,
            borderWidth: borderWidth,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            icon: icon,
            elevation: elevation,
            height: height,
            isLoading: isLoading,
            padding: padding,
            radius: radius,
            textStyle: textStyle,
          ),
        ),
      ],
    );
  }
}
