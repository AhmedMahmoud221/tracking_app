import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_state.dart';
import 'package:live_tracking/features/feature_login/presentation/pages/custom_text_field.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  static const id = '/forgetpassword';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Check your email")));
          GoRouter.of(context).pop();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.forgetpassword),
            backgroundColor: isDark ? Colors.grey[800] : Colors.blue,
            ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Title
                Text(
                  AppLocalizations.of(context)!.enteryouremail,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // Email field
                CustomTextField(
                  hint: 'example@email.com',
                  controller: emailController,
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 30),

                // Button
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final email = emailController.text.trim();
                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!.emailrequired),
                                  ),
                                );
                                return;
                              }

                              context.read<AuthCubit>().forgetPassword(
                                email: email,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // radius أقل
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.resetyourpassword,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
