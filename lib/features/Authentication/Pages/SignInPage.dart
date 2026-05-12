import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/Pages/EmailVerificationPage.dart';

import '../../../core/utils/custom_text.dart';
import '../../../core/widgets/CustomInputFeild.dart';
import '../../../shared/AppColors.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Sign In',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              CustomText(
                text:
                    'Welcome back to CommuteShare. Enter your details to continue your journey.',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(height: 32),

              // Email Field
              const CustomInputField(
                label: 'Email Address',
                hintText: 'name@company.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password Field
              const CustomInputField(
                label: 'Password',
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const CustomText(
                    text: 'Forgot Password?',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.buttonGreen,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const CustomText(
                    text: 'Sign In',
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(
                      text: 'or',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Don't have an account? ",
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to EmailVerificationpage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmailVerificationPage(),
                          ),
                        );
                      },
                      child: const CustomText(
                        text: 'Sign up',
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
  }
}
