import 'package:flutter/material.dart' show FocusManager;

class GestureHelper {
  static void unfocusField() => FocusManager.instance.primaryFocus?.unfocus();
}
