import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';

abstract class ProfileDataState {}

class ProfileDataInitial extends ProfileDataState {}

class ProfileDataLoading extends ProfileDataState {}

class ProfileDataLoaded extends ProfileDataState {
  final UserProfile profile;
  ProfileDataLoaded(this.profile);
}

class ProfileDataError extends ProfileDataState {
  final String message;
  ProfileDataError(this.message);
}
