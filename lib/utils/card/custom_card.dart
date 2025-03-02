import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      // padding: const EdgeInsets.all(AppConstants.screenPadding),
      color: AppColors.navBg.withValues(alpha: 01),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}
