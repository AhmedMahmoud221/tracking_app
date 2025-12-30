import 'package:dartz/dartz.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  // ميثود واحدة تحكمهم جميعاً
  Future<Either<String, MessageEntity>> call(SendMessageParams params) {
    return repository.sendMessage(params);
    // ملاحظة: لازم تعدل الـ Repository عشان يستقبل params بدل String chatId
  }
}

class SendMessageParams {
  final String chatId;
  final String messageType; // 'text', 'image', 'voice', 'video', 'file'
  final String? text;
  final String? mediaPath;

  SendMessageParams({
    required this.chatId,
    required this.messageType,
    this.text,
    this.mediaPath,
  });
}
