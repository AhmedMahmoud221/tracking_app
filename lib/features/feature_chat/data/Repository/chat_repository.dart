import 'package:dartz/dartz.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart'; // لازم يكون موجود هنا كمان

abstract class ChatRepository {
  Future<Either<String, List<ChatEntity>>> getMyChats();
}