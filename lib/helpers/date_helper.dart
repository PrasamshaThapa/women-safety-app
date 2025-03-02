import 'package:flutter/material.dart';

class DateHelper {
  static Future selectDate(
    BuildContext context, {
    required TextEditingController controller,

    void Function(String)? onChanged,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          controller.text.isEmpty
              ? DateTime.now()
              : DateTime.parse(controller.text),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (pickedDate != null) {
      if (onChanged != null) {
        if (controller.text != pickedDate.toString().split(' ').first) {
          onChanged(pickedDate.toString().split(' ').first);
        }
      }
      controller.text = pickedDate.toString().split(' ').first;
    }
  }
}
