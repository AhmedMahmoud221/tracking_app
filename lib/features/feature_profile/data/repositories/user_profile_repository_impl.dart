import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_api.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileApi api;

  UserProfileRepositoryImpl(this.api);

  @override
  Future<UserProfile> getUserProfile() async {
    return await api.fetchUserProfile();
  }
}
