import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_spatial_ride_pooling_system_2/core/constant/ImageConstant.dart';

import '../../../DummyPage.dart';
import '../../../core/utils/custom_text.dart';
import '../../../shared/AppColors.dart';
import 'OnboardingPage.dart';


class Splashpage extends StatefulWidget {
  const Splashpage({Key? key}) : super(key: key);

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  @override
  void initState() {
    super.initState();
    // Timer to transition after 3 seconds
    Timer(const Duration(seconds: 3), () {
      // Replace 'NextScreen()' with your actual home or login widget
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon (SVG)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.buttonGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    ImageConstant.logo, // Ensure path is correct in pubspec.yaml
                    height: 40,
                    width: 40,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Main Title
                CustomText(
                  text: 'CommuteShare',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGreen,
                ),
                const SizedBox(height: 8),

                // Tagline
                CustomText(
                  text: 'Share the ride, split the cost.',
                  fontSize: 14,
                  color: AppColors.black.withOpacity(0.7),
                ),
                const SizedBox(height: 40),

                // Loading Indicator
                const SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonGreen),
                    minHeight: 3,
                  ),
                ),
                const SizedBox(height: 10),

                CustomText(
                  text: 'INITIALIZING',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          // Bottom Footer
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_outlined, size: 16, color: Colors.grey),
                  const SizedBox(height: 4),
                  CustomText(
                    text: 'A Professional Commute System',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}