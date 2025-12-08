
// Profile
// import 'package:get_it/get_it.dart';
// import 'package:live_tracking/features/feature_profile/data/datasources/user_profile_api.dart';
// import 'package:live_tracking/features/feature_profile/data/repositories/user_profile_repository_impl.dart';
// import 'package:live_tracking/features/feature_profile/domain/repositories/user_profile_repository.dart';
// import 'package:live_tracking/features/feature_profile/domain/usecases/get_user_profile_usecase.dart';

// Devices
// import 'package:live_tracking/features/feature_devices/data/datasources/devices_api.dart';
// import 'package:live_tracking/features/feature_devices/data/repositories/device_repository_impl.dart';
// import 'package:live_tracking/features/feature_devices/domain/repositories/device_repository.dart';
// import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list_usecase.dart';
// import 'package:live_tracking/features/feature_devices/domain/usecases/get_device_usecase.dart';
// import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';

// Map
// import 'package:live_tracking/features/feature_map/domain/usecases/get_device_location_usecase.dart';
// import 'package:live_tracking/features/feature_map/presentation/cubit/map_cubit.dart';

// Utils
// import 'package:live_tracking/core/constants/api_constants.dart';
// import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
  // -------------------------------
  // PROFILE
  // -------------------------------
  // sl.registerLazySingleton<UserProfileApi>(
  //     () => UserProfileApi(ApiConstants.baseUrl));

  // sl.registerLazySingleton<UserProfileRepository>(
  //     () => UserProfileRepositoryImpl(sl()));

  // sl.registerLazySingleton<GetUserProfileUseCase>(
  //     () => GetUserProfileUseCase(sl()));

  // sl.registerFactory<ProfileDataCubit>(
  //     () => ProfileDataCubit(sl()));

  // -------------------------------
  // DEVICES
  // -------------------------------
  // sl.registerLazySingleton<DeviceApi>(
  //     () => DeviceApi(ApiConstants.baseUrl));

  // sl.registerLazySingleton<DeviceRepository>(
  //     () => DeviceRepositoryImpl(sl()));

  // sl.registerLazySingleton<GetDevicesListUseCase>(
  //     () => GetDevicesListUseCase(sl()));

  // sl.registerLazySingleton<GetDeviceUseCase>(
  //     () => GetDeviceUseCase(sl()));

  // sl.registerFactory<DevicesCubit>(
  //     () => DevicesCubit(sl()));

  // -------------------------------
  // MAP
  // -------------------------------
//   sl.registerLazySingleton<GetDeviceLocationUseCase>(
//       () => GetDeviceLocationUseCase(sl()));

//   sl.registerFactory<MapCubit>(
//       () => MapCubit(sl()));
// }