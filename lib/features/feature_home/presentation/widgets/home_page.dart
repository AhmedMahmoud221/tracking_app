import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_devices/presentation/bloc/devices_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/home_page_view.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:live_tracking/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Profile provider
        BlocProvider(
          create: (_) => ProfileCubit(LogoutUseCase(AuthService())),
        ),

        // Devices provider
        BlocProvider(
          create: (_) => sl<DevicesCubit>()..fetchDevices(),
        ),
      ],
      child: const HomePageView(),
    );
  }
}