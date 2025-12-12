import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/add_device.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/device_details_page.dart';
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
  static const kGoogleMap = '/google-map';
  static const kCreateDevice = '/create-device';
  static const kDeviceDetails = '/device-details';

  static final router = GoRouter(
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
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => ProfileCubit(LogoutUseCase(AuthService())),
            child: const Profile(),
          );
        },
      ),
      GoRoute(
        path: '/google-map',
        builder: (context, state) {
          final DeviceEntity? device = state.extra as DeviceEntity?;
          return GoogleMapPage(initialDevice: device);
        },
      ),
      GoRoute(path: '/create-device', builder: (context, state) => AddDevice()),
      GoRoute(
        path: '/device-details',
        builder: (context, state) {
          final device = state.extra as DeviceEntity;
          return DeviceDetailsPage(device: device);
        },
      ),
    ],
  );
}
