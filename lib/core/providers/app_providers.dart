import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_message/chat_message_cubit_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_socket/chat_socket_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_google-map/presentation/socket_cubit/map_socket_cubit.dart';
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
    BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()..checkAuthStatus()),
    BlocProvider(create: (context) => sl<ChatMessagesCubit>()),
    BlocProvider<ProfileDataCubit>(create: (_) => sl<ProfileDataCubit>()),
    BlocProvider<LogOutCubit>(create: (_) => sl<LogOutCubit>()),
    BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
    BlocProvider<LanguageCubit>(
      create: (_) => LanguageCubit(sl<LanguageCubit>().state),
    ),
    BlocProvider<DevicesCubit>(
      create: (_) => sl<DevicesCubit>()..fetchDevices(),
    ),
    BlocProvider<CreateDeviceCubit>(create: (_) => sl<CreateDeviceCubit>()),
    BlocProvider<UpdateDeviceCubit>(create: (_) => sl<UpdateDeviceCubit>()),
    BlocProvider<DeleteDeviceCubit>(create: (_) => sl<DeleteDeviceCubit>()),
    BlocProvider<MapSocketCubit>(create: (_) => sl<MapSocketCubit>()),
    BlocProvider<ChatSocketCubit>(create: (context) => sl<ChatSocketCubit>()),
  ];
}
