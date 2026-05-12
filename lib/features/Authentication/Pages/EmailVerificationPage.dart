import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_spatial_ride_pooling_system_2/core/constant/ImageConstant.dart';
import '../../../core/utils/custom_text.dart';
import '../../../core/utils/log.dart';
import '../../../shared/AppColors.dart';
import '../setvice/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'SignInPage.dart';

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
          // Background Image
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
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              onTap: () {
                                _verifyEmail();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    ImageConstant.google_icon,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const CustomText(
                                    text: 'Verify Gmail for Access',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.verified_user_outlined,
                                  color: AppColors.textGreen,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: 'Gmail Verification',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomText(
                                        text:
                                            "We'll use your Google account to securely verify your professional identity and corporate affiliation.",
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
                            text:
                                'By continuing, you agree to our Terms of Service and Privacy Policy. CommuteShare will only access your basic profile information and email address.',
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          // --- ADDED FOOTER HERE ---
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: "Already have an account? ",
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to your Sign In screen here
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInPage(),
                                      ),
                                    );
                                  },
                                  child: const CustomText(
                                    text: 'Sign in',
                                    color: AppColors.buttonGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

      mylog("==================================");
      mylog("USER OBJECT: $user");
      mylog("==================================");

      if (user != null) {
        mylog("UID: ${user.uid}");
        mylog("DISPLAY NAME: ${user.displayName}");
        mylog("EMAIL: ${user.email}");
        mylog("PHONE NUMBER: ${user.phoneNumber}");
        mylog("PHOTO URL: ${user.photoURL}");
        mylog("EMAIL VERIFIED: ${user.emailVerified}");
        mylog("IS ANONYMOUS: ${user.isAnonymous}");
        mylog("TENANT ID: ${user.tenantId}");
        mylog("REFRESH TOKEN: ${user.refreshToken}");

        mylog("CREATION TIME: ${user.metadata.creationTime}");

        mylog("LAST SIGN IN TIME: ${user.metadata.lastSignInTime}");

        for (var provider in user.providerData) {
          mylog("------------ PROVIDER ------------");
          mylog("PROVIDER ID: ${provider.providerId}");
          mylog("PROVIDER UID: ${provider.uid}");
          mylog("NAME: ${provider.displayName}");
          mylog("EMAIL: ${provider.email}");
          mylog("PHONE: ${provider.phoneNumber}");
          mylog("PHOTO URL: ${provider.photoURL}");
        }

        final token = await user.getIdToken();

        mylog("ID TOKEN: $token");

        mylog("==================================");
      }

      if (!mounted) return;

      if (user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Welcome ${user.email}')));
      }
    } on FirebaseAuthException catch (e) {
      mylog("FirebaseAuthException");
      mylog("CODE: ${e.code}");
      mylog("MESSAGE: ${e.message}");
      mylog("STACKTRACE: ${e.stackTrace}");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed')),
      );
    } catch (e, stackTrace) {
      mylog("GENERAL ERROR: $e");
      mylog("STACKTRACE: $stackTrace");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
