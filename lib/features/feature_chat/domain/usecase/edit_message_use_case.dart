import 'package:dartz/dartz.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

class EditMessageUseCase {
  final ChatRepository repository;
  EditMessageUseCase(this.repository);

  Future<Either<String, MessageEntity>> call(String messageId, String newText) {
    return repository.editMessage(messageId, newText);
  }
}