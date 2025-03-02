import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/text_styles.dart';
import '../utils/app_bars/custom_app_bar.dart';
import '../utils/nav_bar/custom_nav_bar.dart';

class HelplineNumbersScreen extends StatelessWidget {
  const HelplineNumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: ""),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(AppConstants.screenPadding),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppConstants.screenPadding),
              child: Text(
                'Helpline Numbers',
                style: TextStyles.bold28.copyWith(color: AppColors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(AppConstants.gesturePadding),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Table(
                  border: TableBorder.all(color: AppColors.background),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Name Of Emergency Service',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Numbers',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    for (var entry in helplineData.entries) ...[
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          CustomNavBar(),
        ],
      ),
    );
  }
}

const helplineData = {
  "Nepal Police": "100",
  "Traffic Support": "103",
  "Women Helpline": "1145",
  "Lalitpur Metropolitan City": "01-5422563",
  "B&B Hospital, Gwarko": "01-5970999",
};
