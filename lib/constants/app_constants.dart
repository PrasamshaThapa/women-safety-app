import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/loader/custom_circular_loader.dart';
import 'app_colors.dart';

class AppConstants {
  static const appName = 'NepaCouri Logistic Rider';

  static const nunitoSans = 'NunitoSans';
  static const poppins = 'Poppins';

  static const idKey = '_id';

  static const staticMethodChannel = 'method_channel';
  static const methodChannelPickImage = 'pickImage';
  static const methodChannelFilePicked = 'imagePicked';

  // ** Dimensions
  static const borderRadius = 20.0;
  static const screenPadding = 20.0;
  static const gesturePadding = 5.0;
  static const smallBorderRadius = 4.0;

  static const dialogWidthFactor = .85;

  static const spaceTopSpaceFactor = .07;

  static const btnSize = 50.0;
  static const mediumBtnSize = 40.0;

  static const largeIconSize = 28.0;
  static const mediumIconSize = 20.0;
  static const smallIconSize = 15.0;

  static const smallAvatarSize = 25.0;
  static const mediumAvatarSize = 45.0;
  static const largeAvatarSize = 90.0;

  static const authIconSize = 65.0;
  static const mediumPadding = 16.0;

  // ** Misc
  static const physics = BouncingScrollPhysics();

  static final shadow = BoxShadow(
    blurRadius: 7,
    offset: const Offset(0, 1),
    spreadRadius: 0,
    color: AppColors.shadow,
  );

  static const systemOverlay = SystemUiOverlayStyle(
    statusBarColor: AppColors.appBg,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.appBg,
    systemNavigationBarDividerColor: AppColors.appBg,
  );
  static const splashDelay = Duration(seconds: 2);

  static const connectionTimeOutDuration = Duration(minutes: 1);

  static const textOverlow = TextOverflow.ellipsis;

  static final overlay = OverlayEntry(
    opaque: false,
    builder: (context) {
      return Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          color: AppColors.appBg.withOpacity(.75),
          child: const CustomCircularLoader(),
        ),
      );
    },
  );
}
