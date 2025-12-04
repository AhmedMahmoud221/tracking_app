import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_splash/presentation/pages/splash_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  
  static const id = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashViewBody(
         nextRoute: '', // هنا مش هتمرر حاجة، هي SplashBody هتقرر بنفسها
      ),
    );
  }
}