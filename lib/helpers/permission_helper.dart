import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_constants.dart';
import '../utils/dialogs/custom_permission_dialog.dart';

class PermissionHelper {
  static String _permissionTitle(String permission) =>
      '${AppConstants.appName} would like to access your $permission';

  static Future _checkPermission({
    required Permission permission,
    required Function onGranted,
    required Function dialog,
  }) async {
    int denyCount = 0;
    await permission.request();
    var status = await permission.status;
    if (status.isDenied) {
      denyCount++;
    }
    if (status.isGranted) {
      onGranted();
    } else if (status.isPermanentlyDenied) {
      dialog();
    } else {
      await permission.request();
      if (denyCount < 1) {
        _checkPermission(
          permission: permission,
          onGranted: onGranted,
          dialog: dialog,
        );
      }
    }
  }

  static Future checkCameraPermission(
    BuildContext context, {
    required Function onGranted,
  }) async {
    await _checkPermission(
      permission: Permission.camera,
      onGranted: () async => await onGranted(),
      dialog:
          () async => await showPermissionDialog(
            context,
            title: _permissionTitle('Camera'),
            description:
                'Our app allows you to capture images directly within the app. Access to the camera enables you to utilize this features seamlessly.',
          ),
    );
  }

  static Future checkLocationPermission(
    BuildContext context, {
    required Function onGranted,
  }) async {
    await _checkPermission(
      permission: Permission.location,
      onGranted: () async => await onGranted(),
      dialog:
          () async => await showPermissionDialog(
            context,
            title: _permissionTitle('Location'),
            description: '',
          ),
    );
  }
}
