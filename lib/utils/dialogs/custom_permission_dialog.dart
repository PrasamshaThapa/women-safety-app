import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/text_styles.dart';

Future showPermissionDialog(
  BuildContext context, {
  required String title,
  required String description,
}) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    useSafeArea: true,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(AppConstants.borderRadius * .5)),
      ),
      child: SizedBox(
        width:
            MediaQuery.of(context).size.width * AppConstants.dialogWidthFactor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.screenPadding * 1.5),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyles.medium14,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    description,
                    style: TextStyles.medium12,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: AlertOutlinedButton(
                    title: 'Don\'t Allow',
                    isLeft: true,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: AlertOutlinedButton(
                    title: 'Allow',
                    isLeft: false,
                    onTap: () {
                      Navigator.pop(context);
                      // openAppSettings();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class AlertOutlinedButton extends StatelessWidget {
  final String title;
  final bool isLeft;
  final VoidCallback onTap;
  const AlertOutlinedButton({
    super.key,
    required this.title,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
          left: !isLeft
              ? BorderSide(width: .5, color: Colors.grey[300]!)
              : BorderSide.none,
          right: isLeft
              ? BorderSide(width: .5, color: Colors.grey[300]!)
              : BorderSide.none,
        ),
      ),
      child: OutlinedButton(
        onPressed: () => onTap(),
        style: const ButtonStyle(
          overlayColor: WidgetStatePropertyAll(AppColors.transparent),
          foregroundColor: WidgetStatePropertyAll(AppColors.black),
          side: WidgetStatePropertyAll(BorderSide(style: BorderStyle.none)),
          textStyle: WidgetStatePropertyAll(
            TextStyles.semi14,
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
