
import 'package:equatable/equatable.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

abstract class ChatMessagesState extends Equatable {
  const ChatMessagesState();

  @override
  List<Object?> get props => [];
}

// الحالة الابتدائية
class ChatMessagesInitial extends ChatMessagesState {}

// حالة التحميل (Loading)
class ChatMessagesLoading extends ChatMessagesState {}

// حالة نجاح جلب الرسائل (Success)
class ChatMessagesSuccess extends ChatMessagesState {
  final List<MessageEntity> messages;

  const ChatMessagesSuccess({required this.messages});

  @override
  List<Object?> get props => [messages];
}

// حالة لو الشات لسه جديد ومفيش فيه رسايل (Empty)
class ChatMessagesEmpty extends ChatMessagesState {}

// حالة حدوث خطأ (Error)
class ChatMessagesError extends ChatMessagesState {
  final String message;

  const ChatMessagesError(this.message);

  @override
  List<Object?> get props => [message];
}