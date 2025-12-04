import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_home/presentation/widgets/home_page.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_login/presentation/widgets/login_page_view.dart';
import 'package:live_tracking/features/feature_login/presentation/widgets/signup_page_view.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/widgets/profile.dart';
import 'package:live_tracking/features/feature_splash/presentation/widgets/splash_view.dart';

class AppRouter {
  static const kSplashView = '/';
  static const kLoginPageView = '/login';
  static const kHomePage = '/home';
  static const kSignupPageView = '/signup';
  static const kProfile = '/profile';

  static final routes = <GoRoute>[
    GoRoute(
      path: kSplashView,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: kLoginPageView,
      builder: (context, state) => const LoginPageView(),
    ),
    GoRoute(
      path: kHomePage,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: kSignupPageView,
      builder: (context, state) => const SignupPageView(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => ProfileCubit(LogoutUseCase(AuthService())),
          child: const Profile(),
        );
      },
    ),
  ];
}
