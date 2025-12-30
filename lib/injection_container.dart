import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/data/datasource/chat_remote_data_source.dart';
import 'package:live_tracking/features/feature_chat/data/datasource/get_chat_messages_use_case.dart';
import 'package:live_tracking/features/feature_chat/domain/repo/chat_repository_impl.dart';
import 'package:live_tracking/features/feature_chat/domain/usecase/send_message_use_case.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/chat_list_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/cubit/chat_message_cubit_cubit.dart';
import 'package:live_tracking/features/feature_devices/data/Repository/device_repo_impl.dart';
import 'package:live_tracking/features/feature_devices/data/datasource/device_remote_datasource.dart';
import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';
import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_google-map/presentation/socket_cubit/socket_cubit.dart';
import 'package:live_tracking/features/feature_home/domain/create_device_use_case.dart';
import 'package:live_tracking/features/feature_home/domain/delete_device_use_case.dart';
import 'package:live_tracking/features/feature_home/domain/update_device_use_case.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/create_device_cubit/create_device_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/delete_device_cubit/delete_device_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/update_device_cubit/update_device_cubit.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:live_tracking/features/feature_profile/domain/repositories/user_profile_repository.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/language_cubit/languageCubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';

final sl = GetIt.instance;

Future<void> init({String savedLang = 'ar'}) async {
  // -----------------------Dio---------------------------
  sl.registerLazySingleton<Dio>(() => Dio());

  // -------------------------Cubit----------------------------
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthService>()));

  sl.registerFactory(() => LanguageCubit(Locale(savedLang)));

  sl.registerFactory(() => SocketCubit());

  sl.registerFactory<ProfileDataCubit>(
    () => ProfileDataCubit(sl<GetUserProfileUseCase>()),
  );

  sl.registerFactory<LogOutCubit>(() => LogOutCubit(sl<LogoutUseCase>()));

  sl.registerFactory(() => DevicesCubit(sl<GetDevicesList>()));

  sl.registerFactory(() => CreateDeviceCubit(sl<CreateDeviceUseCase>()));

  sl.registerFactory(() => UpdateDeviceCubit(sl()));

  sl.registerFactory(() => DeleteDeviceCubit(sl()));

  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  sl.registerFactory(() => ChatListCubit(sl()));

  // ------------------Use Case---------------
  sl.registerLazySingleton<AuthService>(() => AuthService());

  sl.registerLazySingleton(
    () => GetUserProfileUseCase(sl<UserProfileRepository>()),
  );

  sl.registerLazySingleton(() => CreateDeviceUseCase(sl<DeviceRepository>()));

  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthService>()));

  sl.registerLazySingleton(() => GetDevicesList(sl<DeviceRepository>()));

  sl.registerLazySingleton(() => DeleteDeviceUseCase(sl()));

  sl.registerLazySingleton(() => UpdateDeviceUseCase(sl()));

  // ----------------Repository---------------
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(sl<DeviceRemoteDataSource>(), dio: sl<Dio>()),
  );

  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(sl()),
  );

  // -----------------Data source---------------
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(sl<Dio>()),
  );

  //-------------------------Chat------------------------------//
  // -----------------Data source---------------
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(sl<Dio>()), // تأكد إنه بياخد الـ Dio
  );

  // ----------------Repository---------------
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      sl<ChatRemoteDataSource>(), // بياخد الـ DataSource بس
    ),
  );

  // ------------------Use Case---------------
  sl.registerLazySingleton(() => GetChatMessagesUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl<ChatRepository>()));

  // -------------------------Cubit----------------------------
  sl.registerFactory(
    () => ChatMessagesCubit(
      sl<GetChatMessagesUseCase>(),
      sl<SendMessageUseCase>(),
    ),
  );
}
