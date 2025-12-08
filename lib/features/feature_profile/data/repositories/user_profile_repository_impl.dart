import 'package:live_tracking/features/feature_profile/data/datasources/user_profile_api.dart';
import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';
import 'package:live_tracking/features/feature_profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileApi api;

  UserProfileRepositoryImpl(this.api);

  @override
  Future<UserProfile> getUserProfile() async {
    return await api.fetchUserProfile();
  }
}
