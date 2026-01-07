import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';
import 'package:live_tracking/features/feature_profile/domain/repositories/user_profile_repository.dart';

class GetUserProfileUseCase {
  final UserProfileRepository repository;
  GetUserProfileUseCase(this.repository);

  Future<UserProfile> call() async {
    return await repository.getUserProfile();
  }
}
