import 'package:flutter/material.dart';

import '../../helpers/gesture_helper.dart';

class CustomGestureDetector extends StatelessWidget {
  final Widget child;
  const CustomGestureDetector({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: GestureHelper.unfocusField,
      child: child,
    );
  }
}
