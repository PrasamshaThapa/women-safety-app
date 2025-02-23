import 'package:flutter/material.dart';

import '../../helpers/validation_helper.dart';
import 'custom_input.dart';

class CustomMultiLineInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? field;
  final String? errorText;
  const CustomMultiLineInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.field,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      label: label,
      controller: controller,
      maxLines: 4,
      hint: hint ?? '',
      textInputType: TextInputType.multiline,
      errorText: errorText,
      validator: (value) => ValidationHelper.checkMinimumLength(
        value ?? '',
        minLength: 10,
        field: field ?? label,
      ),
    );
  }
}
