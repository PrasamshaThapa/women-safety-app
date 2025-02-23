import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../../constants/text_styles.dart';

Future showCustomDialog(
  BuildContext context, {
  required String title,
  required String description,
  required Widget? Function(BuildContext) action,
}) async =>
    await showDialog(
      barrierDismissible: false,
      context: context,
      useSafeArea: false,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.borderRadius * .5)),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width *
              AppConstants.dialogWidthFactor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.screenPadding * 1.5),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyles.semi14,
                      textAlign: TextAlign.center,
                    ),
                    if (description.isNotEmpty) ...[
                      AppSpaces.medium,
                      Text(
                        description,
                        style: TextStyles.medium14,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              if (action(context) != null) ...[
                action(context)!,
              ],
            ],
          ),
        ),
      ),
    );
