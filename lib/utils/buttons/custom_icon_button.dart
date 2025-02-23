import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../gesture/custom_inkwell.dart';
import '../loader/custom_circular_loader.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;
  final Color color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final bool isLoading;
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconSize = 24,
    this.color = AppColors.white,
    this.backgroundColor = AppColors.transparent,
    this.padding,
    this.radius = 100,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenPadding * .5,
        ),
        child: CustomCircularLoader(
          size: iconSize,
        ),
      );
    }
    return CustomInkWell(
      onTap: () => onTap(),
      borderRadius: radius,
      child: Ink(
        padding:
            padding ?? const EdgeInsets.all(AppConstants.screenPadding * .5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: color,
        ),
      ),
    );
  }
}
