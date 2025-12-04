import 'package:live_tracking/features/feature_profile/domain/repositories/user_profile_repository.dart';

import '../entities/user_profile.dart';

class GetUserProfileUseCase {
  final UserProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfile> call() async {
    return await repository.getUserProfile();
  }
}
