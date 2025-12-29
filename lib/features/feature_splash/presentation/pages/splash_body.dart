import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';

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
  late Animation<double> glowAnimation;
  late Animation<double> shakeAnimation;
  late Animation<double> routeOpacity;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    glowAnimation = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    shakeAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticIn),
    );

    routeOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    animationController.repeat(reverse: true);

    navigateToNextPage();
  }

  @override
  void dispose() {
    animationController.dispose();

    super
        .dispose(); //Unsubscribe from streams and close network connections to avoid memory leaks and ensure the application functions efficiently.
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    Colors.grey[900]!, // رمادي غامق جداً للدارك
                    Colors.grey[900]!,
                  ]
                : [
                    const Color.fromARGB(255, 0, 92, 121), // الأزرق الأصلي للـ Light
                    const Color.fromARGB(255, 79, 229, 255),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(shakeAnimation.value, 0),
                  child: Transform.scale(
                    scale: glowAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? Colors.white24 : const Color(0xFF4FE5FF).withOpacity(0.6)),
                            blurRadius: 30,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_pin,
                        size: 110,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            FadeTransition(
              opacity: routeOpacity,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.10,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  boxShadow: [
                    BoxShadow(
                     color: (isDark ? Colors.white10 : const Color(0xFF4FE5FF).withOpacity(0.6)),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            FadeTransition(
              opacity: animationController,
              child: Column(
                children: const [
                  Text(
                    'Live Tracking',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.3,
                    ),
                  ),
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
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    final token = await SecureStorage.readToken();

    if (token != null) {
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go(AppRouter.kHomePage);
    } else {
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go(AppRouter.kLoginPageView);
    }
  }
}
