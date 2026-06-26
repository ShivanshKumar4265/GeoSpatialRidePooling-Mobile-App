import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/home/bloc/home_bloc.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/home/bloc/home_state.dart';
import 'package:geo_spatial_ride_pooling_system_2/shared/AppColors.dart';

import '../../../core/utils/SnackbarUtil.dart';
import '../../../core/utils/custom_text.dart';
import '../../../core/widgets/app_text.dart';
import '../../Authentication/Pages/SignInPage.dart';
import '../../offer_ride/pages/OfferRidePage.dart';
import '../widgets/commute_card.dart';
import '../widgets/impact_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onMenuPressed;

  const HomeScreen({super.key, required this.onMenuPressed});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Listen reactively to the HomeBloc state to trigger UI overlay logic
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth > 360 ? 20.0 : 14.0;

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            _handleHomeState(context, state);
          },
        ),
      ],
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== STATIC SECTION ====================
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16.0,
                      horizontalPadding,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  // 1. Hamburger Menu Icon
                                  IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      color: Colors.grey.shade800,
                                    ),
                                    onPressed: widget.onMenuPressed,
                                    padding: const EdgeInsets.only(right: 8),
                                    constraints: const BoxConstraints(),
                                    style: IconButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // 2. Greeting Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppText(
                                          text: 'Good Morning, Alex',
                                          fontSize: screenWidth > 360 ? 15 : 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade900,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        AppText(
                                          text: 'Welcome back to CommuteShare',
                                          fontSize: screenWidth > 360 ? 12 : 10,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w400,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 3. Notification Action Icon
                            IconButton(
                              icon: Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.grey.shade800,
                              ),
                              onPressed: () {},
                              padding: const EdgeInsets.only(left: 8),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Search Location Bar Container
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: screenWidth > 360 ? 15 : 13,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Where to?',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.gps_fixed_outlined,
                                color: Colors.grey.shade600,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Ride Selection Buttons Layout
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OfferRidePage(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.directions_car,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: CustomText(
                                  text: 'Offer Ride',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth > 360 ? 14 : 12,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonGreen,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.accessibility_new,
                                  color: Colors.grey.shade800,
                                  size: 16,
                                ),
                                label: CustomText(
                                  text: 'Find Ride',
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth > 360 ? 14 : 12,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade100,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade200),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ==================== SCROLLABLE SECTION ====================
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        24.0,
                        horizontalPadding,
                        16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: 'Your Impact',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 12),

                          // Responsive 6-card Metrics Matrix
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                            children: const [
                              ImpactCard(
                                value: '24',
                                label: 'Rides Taken',
                                icon: Icons.directions_car_rounded,
                                valueColor: Color(0xFF1B5E20),
                                backgroundColor: Color(0xFFF1F8E9),
                              ),
                              ImpactCard(
                                value: '12',
                                label: 'Rides Created',
                                icon: Icons.add_road_rounded,
                                valueColor: Color(0xFFE65100),
                                backgroundColor: Color(0xFFFFF3E0),
                              ),
                              ImpactCard(
                                value: '48',
                                label: 'Shared With',
                                icon: Icons.people_alt_outlined,
                                valueColor: Color(0xFF0D47A1),
                                backgroundColor: Color(0xFFE3F2FD),
                              ),
                              ImpactCard(
                                value: '1,240 km',
                                label: 'Distance Traveled',
                                icon: Icons.map_outlined,
                                valueColor: Color(0xFF4A148C),
                                backgroundColor: Color(0xFFF3E5F5),
                              ),
                              ImpactCard(
                                value: '\$156.50',
                                label: 'Money Saved/Spent',
                                icon: Icons.savings_outlined,
                                valueColor: Color(0xFF004D40),
                                backgroundColor: Color(0xFFE0F2F1),
                              ),
                              ImpactCard(
                                value: '\$320.00',
                                label: 'Money Earned',
                                icon: Icons.account_balance_wallet_outlined,
                                valueColor: Colors.blueAccent,
                                backgroundColor: Color(0xFFF0F4C3),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Recent Feeds Title Header Block
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: 'Recent Commutes',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                ),
                                child: const CustomText(
                                  text: 'View All',
                                  color: AppColors.buttonGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          const CommuteCard(
                            title: 'Office Journey',
                            route: '42 Wall St to Financial District',
                            tags: ['Non-smoking', 'EV Only'],
                            isActive: true,
                          ),
                          const CommuteCard(
                            title: 'Evening Return',
                            route: 'Financial District to 42 Wall St',
                            tags: ['Carpooled 8x'],
                            time: '6:00 PM',
                            icon: Icons.home_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.35),
                // Smooth translucent dark veil
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.buttonGreen,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleHomeState(BuildContext context, HomeState state) {
    switch (state.runtimeType) {
      case StateLogoutFailure:
        final s = state as StateLogoutFailure;
        debugPrint('345678 9 Logout Failure: ${s.error}');

        SnackbarUtil.showSnackbar(
          context,
          message: state.error,
          backgroundColor: Colors.red,
        );

        break;

      case StateLogoutSuccess:
        final s = state as StateLogoutSuccess;

        SnackbarUtil.showSnackbar(
          context,
          message: state.logoutResponse.message,
          backgroundColor: Colors.green,
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (Route<dynamic> route) => false,
        );
        break;
      case StateLogoutLoading:
        final s = state as StateLogoutLoading;
        isLoading = state.isLoading ?? true;
        break;
    }
  }
}
