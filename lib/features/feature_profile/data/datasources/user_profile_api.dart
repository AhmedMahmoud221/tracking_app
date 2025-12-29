// ignore_for_file: avoid_print

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_profile/data/models/user_profile_model.dart';

class UserProfileApi {
  final String baseUrl;

  UserProfileApi(this.baseUrl);

  Future<UserProfileModel> fetchUserProfile() async {
    final token = await SecureStorage.readToken();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/user/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch profile');
    }
  }
}
