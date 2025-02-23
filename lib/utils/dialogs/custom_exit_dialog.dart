import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_dialog.dart';
import 'custom_permission_dialog.dart';

void showExitConfirmationDialog(BuildContext context) {
  showCustomDialog(
    context,
    title: 'EXIT!',
    description: 'Are you sure you want to exit?',
    action: (context) => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: AlertOutlinedButton(
            title: 'YES',
            isLeft: true,
            onTap: () => SystemNavigator.pop(),
          ),
        ),
        Expanded(
          child: AlertOutlinedButton(
            title: 'NO',
            isLeft: false,
            onTap: () => Navigator.pop(context),
          ),
        ),
      ],
    ),
  );
}
