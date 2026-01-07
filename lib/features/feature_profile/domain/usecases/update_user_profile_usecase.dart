import 'dart:io';
import 'package:live_tracking/features/feature_profile/domain/repositories/user_profile_repository.dart';

class UpdateUserProfileUseCase {
  final UserProfileRepository repository;
  UpdateUserProfileUseCase(this.repository);

  Future<void> call({required String name, File? profilePicture}) async {
    return await repository.updateUserProfile(name: name, profilePicture: profilePicture);
  }
}