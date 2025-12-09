import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_splash/presentation/pages/animation.dart';

class SplashViewBody extends StatefulWidget {
  final String nextRoute;
  const SplashViewBody({super.key, required this.nextRoute});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
  with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();

    initSlidingAnimation();

    navigateToNextPage(); // Async navigation after checking token
  }

  @override
  void dispose() {
    animationController
        .dispose();
    
    super.dispose(); //Unsubscribe from streams and close network connections to avoid memory leaks and ensure the application functions efficiently.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(AssetsData.splash),
        ),
        DotsJumpAnimation(),
      ],
    );
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Timer Animathion
    );

    slidingAnimation = Tween<Offset>(
      begin: const Offset(0, 5), // Position Animation Start & End
      end: Offset.zero,
    ).animate(animationController);

    animationController.forward();
  }

  void navigateToNextPage() async {
    // تأكد إن الـ widget موجود قبل أي navigation
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    // جلب الـ token من SecureStorage
    final token = await SecureStorage.readToken();

    if (token != null) {
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go(AppRouter.kHomePage); // لو موجود → Home
    } else {
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go(AppRouter.kLoginPageView); // لو مش موجود → Login
    }
  }  
}
