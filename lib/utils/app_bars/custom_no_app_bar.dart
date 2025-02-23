import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class CustomNoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? navBarColor;
  final Color? statusBarColor;
  final Brightness? androidStatusBarBrightness;
  final Brightness? iosStatusBarBrightness;
  const CustomNoAppBar({
    super.key,
    this.navBarColor,
    this.statusBarColor,
    this.androidStatusBarBrightness,
    this.iosStatusBarBrightness,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: AppConstants.systemOverlay.copyWith(
        statusBarColor: statusBarColor,
        systemNavigationBarColor: navBarColor,
        statusBarBrightness: iosStatusBarBrightness,
        statusBarIconBrightness: androidStatusBarBrightness,
      ),
    );
  }

  @override
  Size get preferredSize => Size.zero;
}
