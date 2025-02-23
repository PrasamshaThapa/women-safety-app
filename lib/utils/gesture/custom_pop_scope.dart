import 'package:flutter/material.dart';

class CustomPopScope extends StatelessWidget {
  final VoidCallback onPop;
  final bool canPop;
  final Widget child;
  const CustomPopScope({
    super.key,
    required this.child,
    required this.onPop,
    this.canPop = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        onPop();
      },
      child: child,
    );
  }
}
