import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            AppConstants.borderRadius,
          ),
        ),
        boxShadow: [
          AppConstants.shadow,
        ],
      ),
      child: child,
    );
  }
}
