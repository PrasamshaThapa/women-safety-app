import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../utils/buttons/expanded_filled_button.dart';
import 'about_us_screen.dart';

class DrawerSection extends StatelessWidget {
  const DrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.lightBackground, // Light pink background
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                // backgroundImage: AssetImage('assets/images/profile_picture.png'),
                backgroundColor: AppColors.background,
                child: Icon(
                  Icons.person,
                  size: AppConstants.largeAvatarSize,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Prasamsha Thapa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'thapapramsha49@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 80),

              ListTile(
                leading: const Icon(Icons.home, color: AppColors.secondary),
                title: const Text('Home'),
                onTap: () {
                  Navigator.maybePop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people, color: AppColors.secondary),
                title: const Text('About Us'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutUsScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning, color: AppColors.secondary),
                title: const Text('Incident Report'),
                onTap: () {
                  // Handle Incident Report navigation
                },
              ),

              const Spacer(),

              ExpandedFilledButton(title: "Logout", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
