import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/bloc/auth_bloc.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/bloc/auth_event.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/bloc/auth_state.dart';
import '../../../DummyPage.dart';
import '../../../core/constant/shared_pref_constant.dart';
import '../../../core/utils/SnackbarUtil.dart';
import '../../../core/utils/custom_text.dart';
import '../../../core/utils/shared_pref_util.dart';
import '../../../core/utils/show_toast_util.dart';
import '../../../core/widgets/CustomInputFeild.dart';
import '../../../shared/AppColors.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String? email;
  final String? name;
  final String? photoUrl;

  const CreatePasswordScreen({
    Key? key,
    required this.email,
    required this.name,
    required this.photoUrl,
  }) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? '';
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          debugPrint("State: $state");
          debugPrint("State Type: ${state.runtimeType}");
          _handleAuthState(context, state);
        },
        builder: (context, state) {
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
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
                            hintText:
                            'alex.walker@corporate.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType:
                            TextInputType.emailAddress,
                            controller: _emailController,
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
                            hintText:
                            'Repeat your password',
                            prefixIcon: Icons.refresh,
                            isPassword: true,
                            controller: _confirmController,
                          ),

                          const SizedBox(height: 24),

                          const Spacer(),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    _onSetPasswordPress();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.buttonGreen,
                    disabledBackgroundColor:
                    AppColors.buttonGreen
                        .withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
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
  
  void _handleAuthState(
      BuildContext context,
      AuthState state,
      ) {
    switch (state.runtimeType) {

      case StateInvalidInput:
        final s = state as StateInvalidInput;

        SnackbarUtil.showSnackbar(
          context,
          message: s.message,
          backgroundColor: Colors.orange,
        );
        break;

      case StateCreatePasswordFailure:
        final s = state as StateCreatePasswordFailure;

        SnackbarUtil.showSnackbar(
          context,
          message: s.error,
          backgroundColor: Colors.red,
        );
        break;

      case StateCreatePasswordSuccess:

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
  
  void _onSetPasswordPress() {
    FocusScope.of(context).unfocus();

    String password =
    _passwordController.text.trim();

    String confirmPassword =
    _confirmController.text.trim();


    context.read<AuthBloc>().add(
      EventCreatePassword(
        email: widget.email ?? '',
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
  }
}
