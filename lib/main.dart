import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/features/feature_home/presentation/cubit/create_device_cubit.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';
import 'package:live_tracking/injection_container.dart';

final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // ← مهم جدًا
  runApp(const LiveTrackingApp());
}

class LiveTrackingApp extends StatelessWidget {
  const LiveTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<ProfileDataCubit>(create: (_) => sl<ProfileDataCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
        BlocProvider<CreateDeviceCubit>(create: (_) => sl<CreateDeviceCubit>()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        title: 'Live Tracking App',
      ),
    );
  }
}
