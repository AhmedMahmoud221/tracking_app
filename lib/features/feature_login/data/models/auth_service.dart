import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';

class AuthService {
  final http.Client client;
  final Dio _dio = Dio();
  
  AuthService({http.Client? client}) : client = client ?? http.Client();

  // login method
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final response = await _dio.post('${ApiConstants.baseUrl}/api/users/login', data: {
      'email': email,
      'password': password,
    });
    
    // بنرجع التوكين والـ ID من الـ JSON اللي شفناه قبل كدة
    return {
      'token': response.data['token'],
      'userId': response.data['data']['user']['_id'],
    };
  }

  // signup method
  Future<String> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/user/register');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Signup failed: ${response.body}');
    }
  }

  // Existing login & signup methods ...
  Future<void> logoutbutton(String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/user/logout');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Logout failed: ${response.body}');
    }
  }

  // Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    final token = await SecureStorage.readToken();
    if (token == null) throw Exception("User not authenticated");

    final url = Uri.parse('${ApiConstants.baseUrl}/api/user/change-password');
    final response = await client.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'newPasswordConfirm': newPasswordConfirm,
      }),
    );

    if (response.statusCode != 200) {
      final error =
          jsonDecode(response.body)['message'] ?? 'Failed to change password';
      throw Exception(error);
    }
  }

  Future<void> forceLogout() async {
    await SecureStorage.deleteToken();
  }

  // forgetPassword
  Future<void> forgetPassword({required String email}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/user/forgot-password');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final error =
          jsonDecode(response.body)['message'] ?? 'Failed to reset password';
      throw Exception(error);
    }
  }
}
