import 'package:dartz/dartz.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  // Existing method for sending text messages
  Future<Either<String, MessageEntity>> call(String chatId, String text) {
    return repository.sendMessage(chatId, text);
  }

  // New method for sending voice messages
  Future<Either<String, MessageEntity>> sendVoice(
    String chatId,
    String filePath,
  ) {
    return repository.sendVoiceMessage(chatId, filePath);
  }

  //  New method for SendMessageImageUseCase
  Future<Either<String, MessageEntity>> sendImage(
    String chatId,
    String imagePath,
  ) async {
    return await repository.sendImage(chatId, imagePath);
  }
}
