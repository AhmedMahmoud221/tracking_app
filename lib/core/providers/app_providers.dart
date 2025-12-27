import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_google-map/presentation/socket_cubit/socket_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/create_device_cubit/create_device_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/delete_device_cubit/delete_device_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/update_device_cubit/update_device_cubit.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/language_cubit/languageCubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';
import 'package:live_tracking/main.dart';

class AppProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
    BlocProvider<ProfileDataCubit>(create: (_) => sl<ProfileDataCubit>()),
    BlocProvider<LogOutCubit>(create: (_) => sl<LogOutCubit>()),
    BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
    BlocProvider<LanguageCubit>(
      create: (_) => LanguageCubit(),
    ), // هذا داخلي لا بأس به

    BlocProvider<DevicesCubit>(
      create: (_) => sl<DevicesCubit>()..fetchDevices(),
    ),
    BlocProvider<CreateDeviceCubit>(create: (_) => sl<CreateDeviceCubit>()),
    BlocProvider<UpdateDeviceCubit>(create: (_) => sl<UpdateDeviceCubit>()),
    BlocProvider<DeleteDeviceCubit>(create: (_) => sl<DeleteDeviceCubit>()),

    // التعديل هنا: استخدم sl لضمان الربط مع الـ injection container
    BlocProvider<SocketCubit>(create: (_) => sl<SocketCubit>()),
  ];
}
        // BlocProvider(
        //   create: (context) =>
        //       UpdateDeviceCubit(UpdateDeviceUseCase(sl<DeviceRepository>())),
        // ),
        // BlocProvider(
        //   create: (context) =>
        //       DevicesCubit(sl<GetDevicesList>())..fetchDevices(),
        // ),
        // BlocProvider(create: (_) => ProfileCubit(LogoutUseCase(AuthService()))),