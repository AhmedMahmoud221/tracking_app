import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_login/presentation/pages/login_body.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});
  
  static const id = '/login';
  @override
  Widget build(BuildContext context) {
    return LoginPageBody();
  }
}