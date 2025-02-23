import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../../constants/text_styles.dart';
import '../buttons/custom_filled_button.dart';

class CustomEmptyWidget extends StatelessWidget {
  final bool isInfo;
  final String? msg;
  final String? btnTitle;
  final VoidCallback? onRetry;
  const CustomEmptyWidget({
    super.key,
    this.isInfo = false,
    this.msg,
    this.onRetry,
    this.btnTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isInfo ? Icons.info_outline : Icons.error_outline,
              size: AppConstants.mediumAvatarSize,
            ),
            AppSpaces.large,
            Text(
              ((msg?.isEmpty ?? true) || msg == 'null')
                  ? 'Sorry, Something Went Wrong!'
                  : msg!,
              style: TextStyles.medium12,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpaces.large,
              CustomFilledButton(
                onTap: () {
                  onRetry!.call();
                },
                height: AppConstants.mediumBtnSize,
                radius: AppConstants.smallBorderRadius,
                title: btnTitle ?? 'Retry',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
