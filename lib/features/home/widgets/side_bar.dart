import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/custom_text.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../../../shared/AppColors.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'drawer_item.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header Profile Container
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: const NetworkImage(
                          'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=200',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: AppColors.buttonGreen,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const CustomText(
                    text: 'Alex Walker',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        size: 16,
                        color: AppColors.buttonGreen,
                      ),
                      const SizedBox(width: 4),
                      const CustomText(
                        text: 'Verified Professional',
                        fontSize: 13,
                        color: AppColors.buttonGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  buildDrawerItem(
                    icon: Icons.home_outlined,
                    title: 'Home',
                    isSelected: true,
                  ),
                  buildDrawerItem(
                    icon: Icons.directions_car_outlined,
                    title: 'My Rides',
                  ),
                  buildDrawerItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Payments & Wallet',
                  ),
                  buildDrawerItem(
                    icon: Icons.badge_outlined,
                    title: 'Professional Identity',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12,
                    ),
                    child: Divider(),
                  ),
                  buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings & Privacy',
                  ),
                  buildDrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                  ),
                  buildDrawerItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About CommuteShare',
                  ),
                ],
              ),
            ),

            // ==================== LOGOUT BUTTON ====================
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      // 1. Grab the BLoC while the sidebar is completely active
                      final homeBloc = context.read<HomeBloc>();

                      // 2. Open the confirmation dialog immediately using the live context
                      _showLogoutConfirmationDialog(context, homeBloc);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          CustomText(
                            text: 'Logout',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext sidebarContext, HomeBloc homeBloc) {
    CustomActionDialog.show(
      context: sidebarContext,
      iconColor: AppColors.buttonGreen,
      title: 'Logout Confirmation',
      message: 'Are you sure you want to logout? You will need to login again to access your rides and profile.',
      secondaryButtonText: 'No, Stay Logged In',
      primaryButtonText: 'Yes, Logout',
      onSecondaryPressed: () {
        // Safe: Closes only the confirmation dialog overlay
        Navigator.pop(sidebarContext);
      },
      onPrimaryPressed: () {
        Navigator.pop(sidebarContext); // 1. Closes the confirmation dialog overlay
        Navigator.pop(sidebarContext); // 2. Closes the sidebar drawer clean
        homeBloc.add(EventLogout());   // 3. Fires the logout routine safely
      },
    );
  }
}