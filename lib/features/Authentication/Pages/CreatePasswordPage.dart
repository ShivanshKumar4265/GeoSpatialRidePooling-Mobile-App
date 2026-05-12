import 'package:flutter/material.dart';
import 'package:geo_spatial_ride_pooling_system_2/core/utils/show_toast_util.dart';
import '../../../core/utils/custom_text.dart';
import '../../../core/widgets/CustomInputFeild.dart';
import '../../../shared/AppColors.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasNumericOrSymbol = false;
  bool passwordsMatch = false;
  bool isEmailValid = false;

  void _checkPasswordStrength(String value) {
    setState(() {
      hasMinLength = value.length >= 8;
      hasUppercase = value.contains(RegExp(r'[A-Z]'));
      hasNumericOrSymbol =
          value.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'));

      passwordsMatch = value == _confirmController.text;
    });
  }

  void _checkConfirmPassword(String value) {
    setState(() {
      passwordsMatch = value == _passwordController.text;
    });
  }

  void _validateEmail(String value) {
    setState(() {
      isEmailValid = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(value);
    });
  }

  bool get isPasswordStrong =>
      hasMinLength &&
          hasUppercase &&
          hasNumericOrSymbol &&
          passwordsMatch &&
          isEmailValid;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,

      // SafeArea ensures content doesn't overlap with status bar/notches
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                // Ensures the content can expand but also scroll if height is limited
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      const CustomText(
                        text: 'Create Password',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),

                      const SizedBox(height: 10),

                      CustomText(
                        text:
                        'Set a strong password to secure your CommuteShare account.',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Email Field
                      CustomInputField(
                        label: 'Email Address',
                        hintText: 'alex.walker@corporate.com',

                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        controller: null,
                        isEditable: false,
                      ),

                      const SizedBox(height: 20),

                      // New Password Field
                      CustomInputField(
                        label: 'New Password',
                        hintText: 'Min. 8 characters',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _passwordController,
                      ),

                      const SizedBox(height: 20),

                      // Confirm Password Field
                      CustomInputField(
                        label: 'Confirm Password',
                        hintText: 'Repeat your password',
                        prefixIcon: Icons.refresh,
                        isPassword: true,
                        controller: _confirmController,
                      ),
                      const SizedBox(height: 24),
                      // Security Requirements Box

                      // Flexible spacer to push the bottom elements down on large screens
                      const Spacer(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // bottomNavigationBar remains fixed at the bottom for all screen sizes
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:  () async {
                    FocusScope.of(context).unfocus();

                    ToastUtil.showToast(message: 'Password set successfully!');
                  }
                      ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    disabledBackgroundColor:
                    AppColors.buttonGreen.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const CustomText(
                    text: 'Set Password',
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const CustomText(
                text:
                'By setting a password, you agree to our Terms of Service and Privacy Policy.',
                fontSize: 11,
                color: Colors.grey,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: isMet
                ? AppColors.buttonGreen
                : Colors.grey.shade400,
          ),

          const SizedBox(width: 10),

          CustomText(
            text: text,
            fontSize: 13,
            color:
            isMet ? AppColors.black : Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}