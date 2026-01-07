import 'package:dio/dio.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_chat/data/models/chat_model.dart';
import 'package:live_tracking/features/feature_chat/data/models/message_model.dart';
import 'package:live_tracking/features/feature_chat/data/models/message_response_model.dart';

class ChatRemoteDataSource {
  final Dio _dio;
  ChatRemoteDataSource(this._dio);

  // Get Chats Method
  Future<ChatResponseModel> getChats() async {
    final token = await SecureStorage.readToken();

    final response = await _dio.get(
      '${ApiConstants.baseUrl}api/chat',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ChatResponseModel.fromJson(response.data);
  }

  // Get Chat Messages Method
  Future<MessageResponseModel> getChatMessages({required String chatId}) async {
    final token = await SecureStorage.readToken();
    final myId = await SecureStorage.readUserId();

    final response = await _dio.get(
      '${ApiConstants.baseUrl}api/chat/message/$chatId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return MessageResponseModel.fromJson(response.data, myId ?? '');
  }

  //============================================================================
  // send message
  Future<MessageModel> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final token = await SecureStorage.readToken();
    final myId = await SecureStorage.readUserId();

    final response = await _dio.post(
      '${ApiConstants.baseUrl}api/chat/message',
      data: {
        'chatId': chatId,
        'receiverId': chatId,
        'text': text,
        'messageType': 'text',
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return MessageModel.fromJson(response.data['data']['message'], myId ?? '');
  }

  Future<MessageModel> sendMediaMessage({
    required String chatId,
    required String filePath,
    required String messageType, // 'image', 'voice', 'video', 'file'
  }) async {
    final token = await SecureStorage.readToken();
    final myId = await SecureStorage.readUserId();

    String fileName = filePath.split('/').last;

    FormData formData = FormData.fromMap({
      'chatId': chatId,
      'receiverId': chatId,
      'messageType': messageType,
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    final response = await _dio.post(
      '${ApiConstants.baseUrl}api/chat/message/media',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return MessageModel.fromJson(
        response.data['data']['message'],
        myId ?? '',
      );
    } else {
      throw Exception("فشل رفع الملف من نوع $messageType");
    }
  }

  Future<List<ChatModel>> searchChats(String query) async {
    try {
      final token = await SecureStorage.readToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}api/user/all',
        queryParameters: {'name': query}, 
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("Search Response: ${response.data}");

      final List usersList = response.data['data']['users'] ?? [];

      return usersList.map((json) => ChatModel.fromJson(json)).toList();
    } catch (e) {
      print("Mapping Error: $e");
      rethrow;
    }
  }
}