import 'dart:io';

import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getUserProfile();
  Future<void> updateUserProfile({required String name, File? profilePicture});
}
