import 'package:flutter/material.dart';

class CenterIcon extends StatelessWidget {
  final Widget icon;
  const CenterIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: icon,
    );
  }
}
