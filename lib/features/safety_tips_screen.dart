import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_spaces.dart';
import '../constants/text_styles.dart';
import '../utils/app_bars/custom_app_bar.dart';
import '../utils/nav_bar/custom_nav_bar.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: ""),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpaces.largeSpace,
        children: [
          Iconify(
            Ic.twotone_health_and_safety,
            size: AppConstants.largeAvatarSize,
            color: AppColors.secondary,
          ),
          Text(
            'Self Protection Tips',
            textAlign: TextAlign.center,
            style: TextStyles.bold24.copyWith(color: AppColors.white),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ), //add padding here instead of in the TipRow
              itemCount: tips.length,
              itemBuilder: (context, index) {
                return TipRow(tip: tips[index], index: index);
              },
            ),
          ),

          CustomNavBar(),
        ],
      ),
    );
  }
}

class TipRow extends StatelessWidget {
  const TipRow({super.key, required this.tip, required this.index});
  final String tip;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: AppConstants.screenPadding,
      ), //space between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.secondary,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

const tips = [
  "Always be aware of your surroundings and trust your instincts.",
  "Keep your phone charged and easily accessible.",
  "Share your location with a trusted friend or family member.",
  "Learn basic self-defense techniques.",
  "Avoid sharing personal information with strangers.",
  "Stay alert while using public transportation.",
];
