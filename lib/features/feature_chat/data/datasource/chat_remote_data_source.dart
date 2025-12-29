import 'package:dio/dio.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_chat/data/models/chat_model.dart';
import 'package:live_tracking/features/feature_chat/data/models/message_response_model.dart';

class ChatRemoteDataSource {
  final Dio _dio;
  ChatRemoteDataSource(this._dio);

  Future<ChatResponseModel> getChats() async {
    final token = await SecureStorage.readToken();

    final response = await _dio.get('${ApiConstants.baseUrl}/api/chat',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));  
    return ChatResponseModel.fromJson(response.data);
  }

  Future<MessageResponseModel> getChatMessages({required String chatId}) async {

    final token = await SecureStorage.readToken();
    final myId = await SecureStorage.readUserId(); 

    final response = await _dio.get(
      '${ApiConstants.baseUrl}/api/chat/message/$chatId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return MessageResponseModel.fromJson(response.data, myId ?? '');
  }
}