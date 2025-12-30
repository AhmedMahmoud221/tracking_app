import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/data/datasource/chat_remote_data_source.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

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

  @override
  Future<Either<String, MessageEntity>> sendMessage(
    String chatId,
    String text,
  ) async {
    try {
      final remoteMessage = await remoteDataSource.sendMessage(
        chatId: chatId,
        text: text,
      );
      return Right(remoteMessage);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "عذراً، تعذر إرسال الرسالة");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MessageEntity>> sendVoiceMessage(
    String chatId,
    String filePath,
  ) async {
    try {
      final result = await remoteDataSource.sendVoiceMessage(
        chatId: chatId,
        filePath: filePath,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MessageEntity>> sendImage(
    String chatId,
    String imagePath,
  ) async {
    try {
      final result = await remoteDataSource.sendImageMessage(
        chatId: chatId,
        imagePath: imagePath,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
