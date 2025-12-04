import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_profile/data/models/user_profile_model.dart';

class UserProfileApi {
  final String baseUrl;

  UserProfileApi(this.baseUrl);

  Future<UserProfileModel> fetchUserProfile() async {
      final token = await SecureStorage.readToken();

  final response = await http.get(
    Uri.parse('$baseUrl/api/user/'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
  print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(jsonDecode(response.body));
    } else {
      
      throw Exception('Failed to fetch profile');
    }
  }
}
