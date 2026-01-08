import 'package:dartz/dartz.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';
import 'package:live_tracking/features/feature_chat/domain/usecase/send_message_use_case.dart'; // لازم يكون موجود هنا كمان

abstract class ChatRepository {
  Future<Either<String, List<ChatEntity>>> getMyChats();

  Future<Either<String, List<MessageEntity>>> getChatMessages(String chatId);

  Future<Either<String, MessageEntity>> sendMessage(SendMessageParams params);

  Future<Either<String, List<ChatEntity>>> searchChats(String query);

  Future<Either<String, MessageEntity>> editMessage(String messageId, String newText);

  Future<Either<String, Unit>> deleteMessage(String messageId);
}
