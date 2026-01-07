import 'dart:io';

import 'package:live_tracking/features/feature_profile/data/datasources/user_profile_data_source.dart';
import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';
import 'package:live_tracking/features/feature_profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource api;

  UserProfileRepositoryImpl(this.api);

  @override
  Future<UserProfile> getUserProfile() async {
    return await api.fetchUserProfile();
  }

  @override
  Future<void> updateUserProfile({required String name, File? profilePicture}) async {
    return await api.updateUserProfile(name: name, profilePicture: profilePicture);
  }
}
