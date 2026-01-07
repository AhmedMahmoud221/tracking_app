import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';

abstract class ChatListState{}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListSuccess extends ChatListState {
  final List<ChatEntity> chats;
  ChatListSuccess(this.chats);
}

class ChatListError extends ChatListState {
  final String message;
  ChatListError(this.message);
}