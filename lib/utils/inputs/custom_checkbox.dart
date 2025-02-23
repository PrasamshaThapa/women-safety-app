import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';

class CustomCheckbox extends StatefulWidget {
  final String text;
  final bool initialValue;
  final Function(bool?)? onChanged;

  const CustomCheckbox({
    super.key,
    this.text = 'OKAY',
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: isChecked,
          activeColor: AppColors.primary,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
            widget.onChanged?.call(value);
          },
        ),
        Text(
          widget.text,
          style: TextStyles.regular14.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}
