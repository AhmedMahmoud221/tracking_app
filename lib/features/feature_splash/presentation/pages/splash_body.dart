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
    animationController.dispose();

    super
        .dispose(); //Unsubscribe from streams and close network connections to avoid memory leaks and ensure the application functions efficiently.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005C79), Color(0xFF4FE5FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1.8),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Curves.easeOutBack,
                    ),
                  ),
              child: Image.asset(
                AssetsData.freepik,
                width: 200,
                fit: BoxFit.contain,
              ),
              //const Icon(
              //   Icons.location_on,
              //   size: 110,
              //   color: Colors.white,
              // ),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: animationController,
              child: Column(
                children: [
                  Text(
                    'Live Tracking',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  DotsJumpAnimation(),
                  // Text(
                  //   'Tracking in real time',
                  //   style: TextStyle(fontSize: 14, color: Colors.black),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
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
