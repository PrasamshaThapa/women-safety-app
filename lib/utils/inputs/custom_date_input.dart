import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../helpers/date_helper.dart';
import '../../helpers/validation_helper.dart';
import 'custom_input.dart';

class CustomDateInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool showPastAndHideFuture;
  final void Function(String value)? onChanged;
  const CustomDateInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint = "",
    this.showPastAndHideFuture = true,
    this.onChanged,
  });

  @override
  State<CustomDateInput> createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  @override
  Widget build(BuildContext context) {
    return CustomInput(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      readOnly: true,
      validator: (value) => ValidationHelper.checkEmptyField(
        value ?? '',
        field: widget.label,
      ),
      suffix: const Icon(
        Icons.calendar_month_outlined,
        size: AppConstants.mediumIconSize,
        color: AppColors.lightText,
      ),
      onTap: () => DateHelper.selectDate(
        context,
        controller: widget.controller,
        showPastAndHideFuture: widget.showPastAndHideFuture,
        onChanged: widget.onChanged,
      ),
    );
  }
}
