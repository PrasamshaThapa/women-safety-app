import 'package:flutter/widgets.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../helpers/date_time_helper.dart';

class CustomCreatedAtWidget extends StatelessWidget {
  final String? createdAt;
  const CustomCreatedAtWidget({
    super.key,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        DateFormatHelper.formatDMY(
          createdAt,
        ),
        style: TextStyles.regular12.copyWith(
          color: AppColors.lightText,
        ),
      ),
    );
  }
}
