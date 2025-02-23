import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/app_colors.dart';

class CustomToasts {
  static void success(
    String? msg, {
    bool cancelPrevious = true,
  }) {
    if (cancelPrevious) Fluttertoast.cancel();
    if (msg?.isNotEmpty ?? false) {
      Fluttertoast.showToast(
        msg: msg ?? '',
        textColor: AppColors.success,
        backgroundColor: AppColors.white,
      );
    }
  }

  static void failure(
    String? msg, {
    bool cancelPrevious = true,
  }) {
    if (cancelPrevious) Fluttertoast.cancel();
    if (msg?.isNotEmpty ?? false) {
      Fluttertoast.showToast(
        msg: msg ?? '',
        textColor: AppColors.danger,
        backgroundColor: AppColors.white,
      );
    }
  }
}
