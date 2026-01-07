// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_profile/data/models/user_profile_model.dart';

class UserProfileDataSource {
  final String baseUrl;

  UserProfileDataSource(this.baseUrl);

  Future<UserProfileModel> fetchUserProfile() async {
    final token = await SecureStorage.readToken();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}api/user/me'),
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
  //=====================================================
  // user_profile_data_source.dart
  Future<void> updateUserProfile({required String name, File? profilePicture}) async {
    final token = await SecureStorage.readToken();
    final url = Uri.parse('${ApiConstants.baseUrl}api/user/update-user');

    try {
      var request = http.MultipartRequest('PATCH', url);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['name'] = name;

      if (profilePicture != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePicture', 
            profilePicture.path,
            contentType: http.MediaType('image', 'jpeg'), 
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Update Response: ${response.body}");
      } else {
        print("Failed to update: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to update profile: ${response.body}");
      }
    } catch (e) {
      print("Error in updateUserProfile: $e");
      rethrow;
    }
  }
}
