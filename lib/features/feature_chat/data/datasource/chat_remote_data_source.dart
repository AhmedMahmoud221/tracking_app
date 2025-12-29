import 'package:dio/dio.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_chat/data/models/chat_model.dart';

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
}