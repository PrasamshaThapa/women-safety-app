import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../../constants/text_styles.dart';
import '../../utils/card/custom_card.dart';
import '../../utils/gesture/custom_inkwell.dart';
import '../contact_management_screen.dart';
import '../helpline_numbers_screen.dart';
import '../map/main_map.dart';
import '../safety_tips_screen.dart';
import 'drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerSection(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          // Using SafeArea to avoid overlapping with system UI
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpaces.largeSpace,
              children: [
                Builder(
                  builder:
                      (BuildContext context) => CustomInkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: EdgeInsets.all(AppConstants.largeIconSize),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary.withValues(alpha: 0.5),
                            image: DecorationImage(
                              image: AssetImage('assets/images/logoo.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Text(
                            "LOGO",
                            style: TextStyle(
                              color: AppColors.secondary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                ),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final user = state.user;

                    return CustomCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.secondary,
                          child:
                              user?.photoURL != ""
                                  ? Image.network(user?.photoURL ?? '')
                                  : Icon(Icons.person),
                        ),
                        title: Text(
                          user?.displayName ?? 'Unknown',
                          style: TextStyles.medium18,
                        ),
                        subtitle: Text(
                          user?.phoneNumber ?? user?.email ?? "",
                          style: TextStyles.medium14,
                        ),
                      ),
                    );
                  },
                ),

                Expanded(
                  //makes gridview take available space and cover the screen
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildFeatureCard(
                        icon: Iconify(
                          Bi.people_fill,
                          size: 40,
                          color: AppColors.secondary,
                        ),
                        title: 'Trusted Contacts Management',
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ContactManagementScreen(),
                              ),
                            ),
                      ),
                      _buildFeatureCard(
                        icon: Iconify(Logos.google_maps, size: 40),
                        title: 'Maps',
                        onTap: () async {
                          PermissionStatus status =
                              await Permission.location.request();

                          if (status.isGranted) {
                            // Navigate to MapPage after permission is granted
                            Navigator.push(
                              context,
                              // MaterialPageRoute(
                              //   builder: (context) => InitialMapScreen(),
                              // ),
                              MaterialPageRoute(
                                builder: (context) => MainMapScreen(),
                              ),
                            );
                          } else {
                            // Show an alert if permission is denied
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Location permission is required to proceed.",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      _buildFeatureCard(
                        icon: Iconify(
                          AntDesign.safety_certificate_twotone,
                          size: 40,
                          color: AppColors.secondary,
                        ),
                        title: 'Safety Tips',
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SafetyTipsScreen(),
                              ),
                            ),
                      ),
                      _buildFeatureCard(
                        icon: Iconify(
                          Mdi.phone_dial,
                          size: 40,
                          color: AppColors.secondary,
                        ),
                        title: 'Helpline Numbers',
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HelplineNumbersScreen(),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required Widget icon,
    required String title,
    required Function onTap,
  }) {
    return CustomInkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            AppSpaces.small,
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
