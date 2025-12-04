import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_state.dart';

class ProfileDataCubit extends Cubit<ProfileDataState> {
  final GetUserProfileUseCase getUserProfile;

  ProfileDataCubit(this.getUserProfile) : super(ProfileDataInitial());

  Future<void> fetchProfile() async {
    emit(ProfileDataLoading());
    try {
      final profile = await getUserProfile();
      emit(ProfileDataLoaded(profile));
    } catch (e) {
      emit(ProfileDataError(e.toString()));
    }
  }
}
