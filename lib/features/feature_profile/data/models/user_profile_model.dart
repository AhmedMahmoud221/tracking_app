import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({required super.name, required super.email});

    factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'] ?? {};
    return UserProfileModel(
      name: user['name'] ?? '',
      email: user['email'] ?? '',
    );
  }
}