import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  static const id = '/change-password';

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration buildDecoration(
      String label,
      bool obscureText,
      VoidCallback toggle,
    ) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: isDark ? Colors.white70 : Colors.grey,
          ),
          onPressed: toggle,
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        title: Text(
          AppLocalizations.of(context)!.changePassword,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 24),
              TextFormField(
                controller: oldPassword,
                obscureText: _obscureOld,
                decoration: buildDecoration(
                  AppLocalizations.of(context)!.oldpassword,
                  _obscureOld,
                  () {
                    setState(() => _obscureOld = !_obscureOld);
                  },
                ),
                validator: (v) => v!.isEmpty
                    ? AppLocalizations.of(context)!.required
                    : null,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: newPassword,
                obscureText: _obscureNew,
                decoration: buildDecoration(
                  AppLocalizations.of(context)!.newpassword,
                  _obscureNew,
                  () {
                    setState(() => _obscureNew = !_obscureNew);
                  },
                ),
                validator: (v) => v!.isEmpty
                    ? AppLocalizations.of(context)!.required
                    : null,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: TextFormField(
                  controller: confirmPassword,
                  obscureText: _obscureConfirm,
                  decoration: buildDecoration(
                    AppLocalizations.of(context)!.confirmpassword,
                    _obscureConfirm,
                    () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppLocalizations.of(context)!.required;
                    }
                    if (v != newPassword.text) {
                      return AppLocalizations.of(context)!.passwordsdonotmatch;
                    }
                    return null;
                  },
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final authService = AuthService();
                        await authService.changePassword(
                          currentPassword: oldPassword.text,
                          newPassword: newPassword.text,
                          newPasswordConfirm: confirmPassword.text,
                        );
                        //if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Password changed successfully, please login again",
                            ),
                          ),
                        );

                        context.go(AppRouter.kLoginPageView);
                      } catch (e) {
                        print('error is $e');
                        // if (!context.mounted) return;
                        context.go(AppRouter.kLoginPageView);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.changePassword,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}
