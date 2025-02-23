import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_spaces.dart';
import '../utils/buttons/custom_filled_button.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splashscreen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (int index) {
            if (index == 1) {
              log("message");
            }
          },
          children: [buildSplashPage(), buildProceedToLoginPage()],
        ),
      ),
    );
  }

  Widget buildSplashPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(0, 20),
          child: Transform.scale(
            scale: 1.1,
            child: Image.asset('assets/images/logo3.png'),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'Welcome',
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(fontSize: 45, color: Colors.black),
          ),
        ),
        const SizedBox(height: 150),
        buildDotsIndicator(),
      ],
    );
  }

  Widget buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: index == 0 ? Colors.black : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget buildProceedToLoginPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: const Offset(0, 20),
            child: Transform.scale(
              scale: 1.1,
              child: Image.asset('assets/images/logo3.png'),
            ),
          ),
          Text(
            'Aashraya is all about women safety. This app is designed to ensure your safety, at all times. Stay positive  with us.',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            textAlign: TextAlign.center,
          ),
          AppSpaces.veryLarge,
          CustomFilledButton(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            title: "Login",
            padding: EdgeInsets.symmetric(horizontal: 100),
          ),
        ],
      ),
    );
  }
}
