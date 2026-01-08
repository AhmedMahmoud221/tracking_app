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
import 'package:live_tracking/l10n/app_localizations.dart';
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
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.errorMessage)),
                ],
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating, // يجعله يظهر بشكل عائم
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else if (state is AuthSuccess) {
          GoRouter.of(context).go(AppRouter.kHomePage); // navigate to MainPage
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
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
                                color: isDark ? Colors.black.withOpacity(0.2) : null,
                                colorBlendMode: isDark ? BlendMode.darken : null,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextFeildHead(title: AppLocalizations.of(context)!.email),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hint: AppLocalizations.of(context)!.enteryouremail,
                              controller: _emailCtrl,
                              isPassword: false,
                            ),
                            const SizedBox(height: 6),
                            CustomTextFeildHead(title: AppLocalizations.of(context)!.password),
                            CustomTextField(
                              hint: AppLocalizations.of(context)!.enteryourpassword,
                              controller: _passwordCtrl,
                              isPassword: true,
                            ),
                            CustomAccountOption(
                              onPressed: () {
                                GoRouter.of(
                                  context,
                                ).go(AppRouter.kSignupPageView);
                              },
                              text1: AppLocalizations.of(context)!.youdonthaveanaccount,
                              text2: AppLocalizations.of(context)!.signup,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(buttonText: AppLocalizations.of(context)!.signin, onTap: _onLoginPressed),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar( SnackBar(content: Text(AppLocalizations.of(context)!.pleasefillallfields)));
      return;
    }

    context.read<AuthCubit>().login(email: email, password: password);
  }
}
