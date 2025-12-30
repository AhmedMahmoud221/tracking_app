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
      '${ApiConstants.baseUrl}/api/chat',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ChatResponseModel.fromJson(response.data);
  }

  // Get Chat Messages Method
  Future<MessageResponseModel> getChatMessages({required String chatId}) async {
    final token = await SecureStorage.readToken();
    final myId = await SecureStorage.readUserId();

    final response = await _dio.get(
      '${ApiConstants.baseUrl}/api/chat/message/$chatId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return MessageResponseModel.fromJson(response.data, myId ?? '');
  }

  // Send Message Method
  Future<MessageModel> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final token = await SecureStorage.readToken();
    final myId = await SecureStorage.readUserId();

    final response = await _dio.post(
      '${ApiConstants.baseUrl}/api/chat/message',
      data: {
        'chatId': chatId, // الـ ID بتاع الروم
        'receiverId':
            chatId, // جرب تضيف السطر ده (لأن في بعض الـ APIs الـ chatId هو نفسه الـ receiverId)
        'text': text,
        'messageType': 'text',
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return MessageModel.fromJson(response.data['data']['message'], myId ?? '');
  }

  // Send Voice Message Method
  Future<MessageModel> sendVoiceMessage({
    required String chatId,
    required String filePath, // مسار الملف المسجل في الموبايل
  }) async {
    final token = await SecureStorage.readToken();
    final myId = await SecureStorage.readUserId();

    FormData formData = FormData.fromMap({
      'chatId': chatId,
      'receiverId': chatId,
      'messageType': 'voice',
      'file': await MultipartFile.fromFile(
        filePath,
        filename: 'voice_note.aac',
      ),
    });

    final response = await _dio.post(
      '${ApiConstants.baseUrl}/api/chat/message/media',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return MessageModel.fromJson(response.data['data']['message'], myId ?? '');
  }

  // Send Image message method
  Future<MessageModel> sendImageMessage({
    required String chatId,
    required String imagePath,
  }) async {
    try {
      final token = await SecureStorage.readToken();
      final myId = await SecureStorage.readUserId();

      String fileName = imagePath.split('/').last;
      FormData formData = FormData.fromMap({
        "chatId": chatId,
        "receiverId": chatId,
        "messageType": "image",
        "file": await MultipartFile.fromFile(imagePath, filename: fileName),
      });

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/chat/message/media',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MessageModel.fromJson(
          response.data['data']['message'],
          myId ?? '',
        );
      } else {
        throw Exception("فشل رفع الصورة");
      }
    } catch (e) {
      rethrow;
    }
  }
}
