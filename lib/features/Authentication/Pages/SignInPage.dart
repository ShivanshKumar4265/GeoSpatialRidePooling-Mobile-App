import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/Pages/EmailVerificationPage.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/bloc/auth_event.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/bloc/auth_state.dart';

import '../../../DummyPage.dart';
import '../../../core/utils/SnackbarUtil.dart';
import '../../../core/utils/custom_text.dart';
import '../../../core/utils/show_toast_util.dart';
import '../../../core/widgets/CustomInputFeild.dart';
import '../../../shared/AppColors.dart';
import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        _handleAuthState(context, state);
      },
      builder: (context, state) {
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
                  CustomInputField(
                    label: 'Email Address',
                    hintText: 'name@company.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  CustomInputField(
                    label: 'Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
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
                      onPressed: () {
                        _onPressedSignIn();
                      },
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
                                builder: (
                                    context) => const EmailVerificationPage(),
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
      },
    );
  }

  void _handleAuthState(
      BuildContext context,
      AuthState state,
      ) {
    switch (state.runtimeType) {

      case StateLoginInvalidInput:
        final s = state as StateLoginInvalidInput;

        SnackbarUtil.showSnackbar(
          context,
          message: s.message,
          backgroundColor: Colors.orange,
        );
        break;

      case StateLoginFailure:
        final s = state as StateLoginFailure;

        SnackbarUtil.showSnackbar(
          context,
          message: s.error,
          backgroundColor: Colors.red,
        );
        break;

      case StateLoginSuccess:

        ToastUtil.showToast(
          message: "Password created successfully. Redirecting...",
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Dummypage(),
          ),
        );
        break;
    }
  }

  void _onPressedSignIn() {
    FocusScope.of(context).unfocus();

    String password =
    _passwordController.text.trim();

    String email = _emailController.text.trim();


    context.read<AuthBloc>().add(
      EventLogin(
        email: email ?? '',
        password: password ?? '',
      ),
    );
  }
}
