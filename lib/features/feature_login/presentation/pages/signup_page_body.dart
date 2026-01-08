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

class SignupPageBody extends StatefulWidget {
  const SignupPageBody({super.key});

  @override
  State<SignupPageBody> createState() => _SignupPageBodyState();
}

class _SignupPageBodyState extends State<SignupPageBody> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          GoRouter.of(context).go(AppRouter.kLoginPageView);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account created successfully!"),
            backgroundColor: Colors.green,  
            )
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const LiveTrackingText(),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                AssetsData.signup,
                                height: 300,
                                width: 350,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextFeildHead(title: AppLocalizations.of(context)!.username),
                            CustomTextField(
                              hint: AppLocalizations.of(context)!.enteryourusername,
                              controller: _nameCtrl,
                              isPassword: false,
                            ),
                            CustomTextFeildHead(title: AppLocalizations.of(context)!.email),
                            CustomTextField(
                              hint: AppLocalizations.of(context)!.enteryouremail,
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              isPassword: false,
                            ),
                            CustomTextFeildHead(title: AppLocalizations.of(context)!.password),
                            CustomTextField(
                              hint: AppLocalizations.of(context)!.enteryourpassword,
                              controller: _passwordCtrl,
                              isPassword: true,
                            ),
                            CustomTextFeildHead(
                              title: AppLocalizations.of(context)!.confirmpassword,
                            ),
                            CustomTextField(
                              hint: AppLocalizations.of(context)!.confirmpassword,
                              controller: _confirmCtrl,
                              isPassword: true,
                            ),
                            CustomAccountOption(
                              onPressed: () {
                                GoRouter.of(
                                  context,
                                ).go(AppRouter.kLoginPageView);
                              },
                              text1: AppLocalizations.of(context)!.alreadyhaveanaccount,
                              text2: AppLocalizations.of(context)!.signin,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      buttonText: AppLocalizations.of(context)!.signup,
                      onTap: _onSignupPressed,
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

  bool _validateForm() {
    if (_nameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _passwordCtrl.text.isEmpty ||
        _confirmCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar( SnackBar(content: Text(AppLocalizations.of(context)!.pleasefillallfields)));
      return false;
    }

    if (_passwordCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar( SnackBar(content: Text(AppLocalizations.of(context)!.passwordsdonotmatch)));
      return false;
    }

    return true;
  }

  void _onSignupPressed() {
    if (!_validateForm()) return;

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final passwordConfirm = _confirmCtrl.text.trim();

    context.read<AuthCubit>().signup(
      name: name,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );
  }
}
