import 'package:dio/dio.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio}) : _dio = dio ?? Dio();

  // 1. Login Method
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}api/user/login',
      data: {'email': email, 'password': password},
    );

    return {
      'token': response.data['token'],
      'userId': response.data['data']['user']['_id'],
    };
  }

  //--------------------------------------------
  // 2. Signup Method
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}api/user/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      },
    );
    return {
      'token': response.data['token'],
      'userId': response.data['data']['user']['_id'],
    };
  }

  //--------------------------------------------
  // 3. Logout Method
  Future<void> logoutbutton(String token) async {
    await _dio.get(
      '${ApiConstants.baseUrl}api/user/logout',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  //--------------------------------------------
  // 4. Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    final token = await SecureStorage.readToken();
    if (token == null) throw Exception("User not authenticated");

    await _dio.patch(
      '${ApiConstants.baseUrl}api/user/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'newPasswordConfirm': newPasswordConfirm,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  //--------------------------------------------
  // 5. Forget Password
  Future<void> forgetPassword({required String email}) async {
    await _dio.post(
      '${ApiConstants.baseUrl}api/user/forgot-password',
      data: {'email': email},
    );
  }

  Future<void> forceLogout() async {
    await SecureStorage.deleteToken();
  }
}
