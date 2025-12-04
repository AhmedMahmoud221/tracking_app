import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_state.dart';
import 'package:live_tracking/features/feature_login/presentation/pages/custom_account_option.dart';
import 'package:live_tracking/features/feature_login/presentation/pages/custom_button.dart';
import 'package:live_tracking/features/feature_login/presentation/pages/custom_text_feild_head.dart';
import 'package:live_tracking/features/feature_login/presentation/pages/custom_text_field.dart';
import 'package:live_tracking/features/feature_login/presentation/pages/live_tracking_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        } else if (state is AuthSuccess) {
          GoRouter.of(context).go(AppRouter.kHomePage); // navigate to MainPage
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const LiveTrackingText(),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                AssetsData.login,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const CustomTextFeildHead(title: 'Email'),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hint: 'Enter your email',
                              controller: _emailCtrl,
                              isPassword: false,
                            ),
                            const SizedBox(height: 6),
                            const CustomTextFeildHead(title: 'Password'),
                            CustomTextField(
                              hint: 'Enter your password',
                              controller: _passwordCtrl,
                              isPassword: true,
                            ),
                            CustomAccountOption(
                              onPressed: () {
                                GoRouter.of(context)
                                    .go(AppRouter.kSignupPageView);
                              },
                              text1: 'You don\'t have an account ?',
                              text2: 'Sign Up',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      buttonText: 'Sign In',
                      onTap: _onLoginPressed,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onLoginPressed() {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    context.read<AuthCubit>().login(email: email, password: password);
  }
}
