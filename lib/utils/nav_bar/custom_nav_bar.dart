import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../features/home/home_screen.dart';
import '../gesture/custom_inkwell.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return // Bottom Navigation
    Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 100,
          margin: EdgeInsets.only(top: AppConstants.screenPadding),
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(200, 100),
            ),
          ),
          child: const Center(
            child: Text("data", style: TextStyle(color: AppColors.secondary)),
          ),
        ),
        CustomInkWell(
          onTap:
              () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => HomeScreen())),
          child: CircleAvatar(
            radius: AppConstants.mediumAvatarSize,
            backgroundColor: AppColors.lightBackground,
            child: Icon(
              Icons.home,
              size: AppConstants.mediumAvatarSize,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
