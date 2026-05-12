import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_spatial_ride_pooling_system_2/core/constant/ImageConstant.dart';

import '../../../core/utils/custom_text.dart';
import '../../../shared/AppColors.dart';
import '../../Authentication/Pages/EmailVerificationPage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon (SVG) - Plain green as per image
                  SvgPicture.asset(
                    ImageConstant.logo, // Ensure path is correct
                    height: 80,
                    width: 80,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textGreen,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Title
                  CustomText(
                    text: 'CommuteShare',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGreen,
                  ),

                  // Subtitle
                  CustomText(
                    text: 'Professional Daily Carpooling',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGreen.withOpacity(0.8),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 30.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // SnackbarUtil.showSnackbar(
                          //   context,
                          //   message: 'Navigating to Email Verification...',
                          //   backgroundColor: AppColors.buttonGreen,
                          // );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder:
                                  (context) => const EmailVerificationPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const CustomText(
                          text: 'Get Started',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Version and Platform Info
                    CustomText(
                      text: 'Version 1.0.2 • Secure Enterprise Platform',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
