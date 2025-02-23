import 'package:flutter/material.dart';

import 'splash_screen.dart';

class WomenSafetyApp extends StatelessWidget {
  const WomenSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Scaffold(body: SplashScreen()));
  }
}
