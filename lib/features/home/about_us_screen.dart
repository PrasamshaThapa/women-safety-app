import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../utils/app_bars/custom_app_bar.dart';
import '../../utils/nav_bar/custom_nav_bar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "About Us"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset('assets/images/about_us.png', height: 200),
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                title: "Our Purpose",
                description:
                    "Our purpose is to empower women by providing reliable tools and technology for personal safety. We aim to create a secure environment where women feel confident and protected, offering features like live location sharing, safe route navigation, and trusted contacts. At Aashraya, we believe safety is a right, not a privilege.",
              ),
              _buildInfoCard(
                title: "Our Approach",
                description:
                    "We combine innovative technology with user-friendly design to create a reliable safety net for women. By focusing on real-time solutions, proactive alerts, and seamless communication, we ensure safety is always within reach.",
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomNavBar(),
    );
  }

  Widget _buildInfoCard({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
