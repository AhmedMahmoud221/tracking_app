import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_home/presentation/widgets/home_page.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_login/presentation/widgets/login_page_view.dart';
import 'package:live_tracking/features/feature_login/presentation/widgets/signup_page_view.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/widgets/profile.dart';
import 'package:live_tracking/features/feature_splash/presentation/widgets/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LiveTrackingApp());
}

class LiveTrackingApp extends StatelessWidget {
  const LiveTrackingApp({super.key,});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/',  //splash first
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashView(), // Splash handle token itself
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPageView(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupPageView(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        // ⬇⬇⬇ هنا تحط الـ Profile + Provider
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            return BlocProvider(
              create: (_) =>
                  ProfileCubit(LogoutUseCase(AuthService())),
              child: const Profile(),
            );
          },
        ),
      ],
    );

    return BlocProvider(
      create: (context) => AuthCubit(AuthService()),
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Live Tracking App',
      ),
    );
  }
}
