import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
// import 'package:live_tracking/features/feature_google-map/data/data_sources/device_remote_data_source.dart';
// import 'package:live_tracking/features/feature_google-map/data/repostories/device_repository_impl.dart';
// import 'package:live_tracking/features/feature_google-map/domain/usecases/get_device_map.dart';
// import 'package:live_tracking/features/feature_google-map/presentation/bloc/map_cubit.dart';
// import 'package:live_tracking/features/feature_google-map/presentation/pages/google_map_page.dart';
import 'package:live_tracking/features/feature_home/presentation/widgets/home_page.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
// import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_login/presentation/widgets/login_page_view.dart';
import 'package:live_tracking/features/feature_login/presentation/widgets/signup_page_view.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';
// import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/widgets/profile.dart';
import 'package:live_tracking/features/feature_splash/presentation/widgets/splash_view.dart';
import 'package:live_tracking/injection_container.dart';

final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await init(); // ← مهم جدًا
  runApp(const LiveTrackingApp());
}

class LiveTrackingApp extends StatelessWidget {
  const LiveTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
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

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<ProfileDataCubit>(create: (_) => sl<ProfileDataCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>(),),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Live Tracking App',
      ),
    );
  }
}
