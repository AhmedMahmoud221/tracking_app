import 'package:dartz/dartz.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/data/datasource/chat_remote_data_source.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';

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
}