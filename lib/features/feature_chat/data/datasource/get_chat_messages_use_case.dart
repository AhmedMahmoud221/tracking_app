import 'package:dartz/dartz.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

class GetChatMessagesUseCase {
  final ChatRepository repository;
  GetChatMessagesUseCase(this.repository);

  Future<Either<String, List<MessageEntity>>> call(String chatId) {
    return repository.getChatMessages(chatId);
  }
}