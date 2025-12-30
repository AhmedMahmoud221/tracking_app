import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/add_device.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/device_details_page.dart';
import 'package:live_tracking/features/feature_google-map/presentation/pages/google_map_page.dart';
import 'package:live_tracking/features/feature_home/presentation/widgets/home_page.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_state.dart';
import 'package:live_tracking/features/feature_login/presentation/pages/forget_password_screen.dart';
import 'package:live_tracking/features/feature_login/presentation/widgets/login_page_view.dart';
import 'package:live_tracking/features/feature_login/presentation/widgets/signup_page_view.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/change_password_page.dart';
import 'package:live_tracking/features/feature_profile/presentation/widgets/profile.dart';
import 'package:live_tracking/features/feature_splash/presentation/widgets/splash_view.dart';

class AppRouter {
  static const kSplashView = '/';
  static const kLoginPageView = '/login';
  static const kHomePage = '/home';
  static const kSignupPageView = '/signup';
  static const kProfile = '/profile';
  static const kGoogleMap = '/google-map';
  static const kAddEditDevice = '/add_edit-device';
  static const kDeviceDetails = '/device-details';
  static const kChangePassword = '/change-password';
  static const kForgotPassword = '/forgotPassword';

  static final router = GoRouter(
    initialLocation: '/', //splash first

    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;

      // لو إحنا في صفحة الـ Splash وبنشوف هنروح فين
      if (state.fullPath == '/') {
        if (authState is AuthSuccess) return kHomePage;
        if (authState is AuthInitial || authState is AuthFailure) {
          return kLoginPageView;
        }
      }

      return null; // كمل في طريقك عادي لو مفيش شرط تحقق
    },

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
      GoRoute(
        path: kForgotPassword,
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => LogOutCubit(LogoutUseCase(AuthService())),
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
      GoRoute(
        path: '/add_edit-device',
        builder: (context, state) {
          final device = state.extra as DeviceEntity?;
          return AddEditDevicePage(device: device);
        },
      ),
      GoRoute(
        path: '/device-details',
        builder: (context, state) {
          final device = state.extra as DeviceEntity;
          return DeviceDetailsPage(device: device);
        },
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
    ],
  );
}
