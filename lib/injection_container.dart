import 'package:get_it/get_it.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_login/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';

final sl = GetIt.instance;


Future<void> init() async {
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthService>()));
  sl.registerFactory<ProfileDataCubit>(() => ProfileDataCubit(sl<GetUserProfileUseCase>()));
}