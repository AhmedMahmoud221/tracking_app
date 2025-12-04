import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_login/data/models/user_model.dart';

class UserService {
  final http.Client client;

  UserService({http.Client? client}) : client = client ?? http.Client();

  Future<UserModel> getUserProfile() async {
    final token = await SecureStorage.readToken();
    if (token == null) throw Exception('User not logged in');

    final url = Uri.parse('${ApiConstants.baseUrl}api/user');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return UserModel.fromJson(decoded['data']['user']);
    } else {
      throw Exception('Failed to load profile: ${response.body}');
    }
  }
}
