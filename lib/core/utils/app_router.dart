import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_google-map/presentation/pages/google_map_page.dart';
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
  static const kGoogleMap = '/googlemap';

  static final  router = GoRouter(
      initialLocation: '/', //splash first
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const SplashView(), // Splash handle token itself
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPageView(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupPageView(),
        ),
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        // ⬇⬇⬇ هنا تحط الـ Profile + Provider
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => ProfileCubit(LogoutUseCase(AuthService())),
              child: const Profile(),
            );
          },
        ),
        // GoRoute(
        //   path: '/map',
        //   builder: (context, state) {
        //     return BlocProvider(
        //       create: (_) => MapCubit(
        //         getDevices: GetDevices(
        //           DeviceRepositoryImpl(DeviceRemoteDataSource()),
        //         ),
        //       ),
        //       child: const GoogleMapPage(),
        //     );
        //   },
        // ),
      ],
    );
}
