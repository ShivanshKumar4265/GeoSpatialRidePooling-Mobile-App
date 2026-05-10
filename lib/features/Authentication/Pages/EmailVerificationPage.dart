import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_spatial_ride_pooling_system_2/core/constant/ImageConstant.dart';

import '../../../core/utils/custom_text.dart';
import '../../../shared/AppColors.dart';
import '../setvice/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final AuthService _authService = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background Image (The road rays effect)
          Positioned.fill(
            child: Image.asset(
              ImageConstant.backround_email,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          IconButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            icon: const Icon(Icons.arrow_back, color: AppColors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(height: 40),

                          // Header Text
                          const CustomText(
                            text: 'Welcome to',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          const CustomText(
                            text: 'CommuteShare',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          const SizedBox(height: 12),
                          CustomText(
                            text: 'Sign in to join your corporate network',
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(height: 48),

                          // Google Sign-In Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: ()  {
                                _verifyEmail();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Use an SVG for the Google Logo
                                  SvgPicture.asset(
                                    ImageConstant.google_icon,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const CustomText(
                                    text: 'Continue with Google',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Verification Info Box
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.verified_user_outlined,
                                    color: AppColors.textGreen, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: 'Gmail Verification',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomText(
                                        text: "We'll use your Google account to securely verify your professional identity and corporate affiliation.",
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Legal Disclaimer
                          CustomText(
                            text: 'By continuing, you agree to our Terms of Service and Privacy Policy. CommuteShare will only access your basic profile information and email address.',
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),

                          // Spacer to push help text to bottom
                          const SizedBox(height: 40),

                          // Footer Link
                          // Center(
                          //   child: TextButton(
                          //     onPressed: () {},
                          //     child: const CustomText(
                          //       text: 'Need help signing in?',
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w500,
                          //       color: AppColors.textGreen,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyEmail() async {
    try {
      final user = await _authService.signInWithGoogle();

      log("==================================");
      log("USER OBJECT: $user");
      log("==================================");

      if (user != null) {
        log("UID: ${user.uid}");
        log("DISPLAY NAME: ${user.displayName}");
        log("EMAIL: ${user.email}");
        log("PHONE NUMBER: ${user.phoneNumber}");
        log("PHOTO URL: ${user.photoURL}");
        log("EMAIL VERIFIED: ${user.emailVerified}");
        log("IS ANONYMOUS: ${user.isAnonymous}");
        log("TENANT ID: ${user.tenantId}");
        log("REFRESH TOKEN: ${user.refreshToken}");

        log(
          "CREATION TIME: ${user.metadata.creationTime}",
        );

        log(
          "LAST SIGN IN TIME: ${user.metadata.lastSignInTime}",
        );

        for (var provider in user.providerData) {
          log("------------ PROVIDER ------------");
          log("PROVIDER ID: ${provider.providerId}");
          log("PROVIDER UID: ${provider.uid}");
          log("NAME: ${provider.displayName}");
          log("EMAIL: ${provider.email}");
          log("PHONE: ${provider.phoneNumber}");
          log("PHOTO URL: ${provider.photoURL}");
        }

        final token = await user.getIdToken();

        log("ID TOKEN: $token");

        log("==================================");
      }

      if (!mounted) return;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome ${user.email}',
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException");
      log("CODE: ${e.code}");
      log("MESSAGE: ${e.message}");
      log("STACKTRACE: ${e.stackTrace}");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Authentication failed',
          ),
        ),
      );
    } catch (e, stackTrace) {
      log("GENERAL ERROR: $e");
      log("STACKTRACE: $stackTrace");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }}