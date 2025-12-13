import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';

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

    InputDecoration _buildDecoration(
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
          "Change Password",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
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
                decoration: _buildDecoration("Old Password", _obscureOld, () {
                  setState(() => _obscureOld = !_obscureOld);
                }),
                validator: (v) => v!.isEmpty ? "Required" : null,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: newPassword,
                obscureText: _obscureNew,
                decoration: _buildDecoration("New Password", _obscureNew, () {
                  setState(() => _obscureNew = !_obscureNew);
                }),
                validator: (v) => v!.isEmpty ? "Required" : null,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: TextFormField(
                  controller: confirmPassword,
                  obscureText: _obscureConfirm,
                  decoration: _buildDecoration(
                    "Confirm Password",
                    _obscureConfirm,
                    () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Required";
                    if (v != newPassword.text) return "Passwords do not match";
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

                        await SecureStorage.deleteToken();

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Password changed successfully, please login again",
                            ),
                          ),
                        );

                        context.go(AppRouter.kLoginPageView);
                      } catch (e) {
                        if (!context.mounted) return;
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
                  child: const Text(
                    "Change Password",
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
