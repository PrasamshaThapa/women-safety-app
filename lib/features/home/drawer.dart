import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../utils/buttons/expanded_filled_button.dart';
import 'about_us_screen.dart';
import 'incident_report_screen.dart';

class DrawerSection extends StatelessWidget {
  const DrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        return Drawer(
          backgroundColor: AppColors.lightBackground, // Light pink background
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(user?.photoURL ?? ''),
                    backgroundColor: AppColors.background,
                    // child: Icon(
                    //   Icons.person,
                    //   size: AppConstants.largeAvatarSize,
                    //   color: AppColors.secondary,
                    // ),
                    child:
                        user?.photoURL != ""
                            ? Image.network(
                              user?.photoURL ?? '',
                              height: AppConstants.mediumAvatarSize,
                            )
                            : Icon(Icons.person),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user?.displayName ?? 'Unknown',

                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.phoneNumber ?? user?.email ?? "",
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
                    leading: const Icon(
                      Icons.people,
                      color: AppColors.secondary,
                    ),
                    title: const Text('About Us'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AboutUsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: AppColors.secondary,
                    ),
                    title: const Text('Incident Report'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => IncidentReportScreen(),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  ExpandedFilledButton(title: "Logout", onTap: () {}),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
