import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/data/datasource/chat_remote_data_source.dart';
import 'package:live_tracking/features/feature_chat/data/models/message_model.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';
import 'package:live_tracking/features/feature_chat/domain/usecase/send_message_use_case.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<ChatEntity>>> getMyChats() async {
    try {
      final response = await remoteDataSource.getChats();
      return Right(response.chats);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<MessageEntity>>> getChatMessages(
    String chatId,
  ) async {
    try {
      final response = await remoteDataSource.getChatMessages(chatId: chatId);
      return Right(response.messages);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Failed to load messages");
    } catch (e) {
      return Left(e.toString());
    }
  }

  //============================================================================
  @override
  Future<Either<String, MessageEntity>> sendMessage(
    SendMessageParams params,
  ) async {
    try {
      MessageModel result;
      if (params.messageType == 'text') {
        result = await remoteDataSource.sendMessage(
          chatId: params.chatId,
          text: params.text ?? "",
        );
      } else {
        // أي حاجة تانية غير النص هتروح للميثود الموحدة
        result = await remoteDataSource.sendMediaMessage(
          chatId: params.chatId,
          filePath: params.mediaPath!,
          messageType: params.messageType,
        );
      }
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
