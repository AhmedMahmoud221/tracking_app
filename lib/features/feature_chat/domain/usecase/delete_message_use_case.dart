import 'package:dartz/dartz.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';

class DeleteMessageUseCase {
  final ChatRepository repository;
  DeleteMessageUseCase(this.repository);

  Future<Either<String, Unit>> call(String messageId) {
    return repository.deleteMessage(messageId);
  }
}