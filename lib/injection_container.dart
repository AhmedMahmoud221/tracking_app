import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/features/feature_devices/data/Repository/device_repo_impl.dart';
import 'package:live_tracking/features/feature_devices/data/datasource/device_remote_datasource.dart';
import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';
import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_home/domain/create_device_use_case.dart';
import 'package:live_tracking/features/feature_home/presentation/cubit/create_device_cubit.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());
  // -------------------------------
  // Cubit
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthService>()));

  sl.registerFactory<ProfileDataCubit>(
    () => ProfileDataCubit(sl<GetUserProfileUseCase>()),
  );

  sl.registerFactory(() => DevicesCubit(sl<GetDevicesList>()));

  sl.registerFactory(() => CreateDeviceCubit(sl<CreateDeviceUseCase>()));

  sl.registerLazySingleton(() => CreateDeviceUseCase(sl<DeviceRepository>()));

  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // -------------------------------
  // Use Case
  sl.registerLazySingleton<AuthService>(() => AuthService());

  sl.registerLazySingleton(() => GetDevicesList(sl<DeviceRepository>()));

  // -------------------------------
  // Repository
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(sl<DeviceRemoteDataSource>()),
  );

  // -------------------------------
  // Data source
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(sl<Dio>()),
  );
}
