import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/data/datasource/get_chat_messages_use_case.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';
import 'package:live_tracking/features/feature_chat/domain/usecase/send_message_use_case.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/cubit/chat_message_cubit_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetChatMessagesUseCase getChatMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatMessagesCubit(this.getChatMessagesUseCase, this.sendMessageUseCase)
    : super(ChatMessagesInitial());
  final TextEditingController messageController = TextEditingController();

  // fetch chat messages
  Future<void> fetchMessages(String chatId) async {
    emit(ChatMessagesLoading());

    final result = await getChatMessagesUseCase(chatId);

    result.fold((error) => emit(ChatMessagesError(error)), (messages) {
      if (messages.isEmpty) {
        emit(ChatMessagesEmpty());
      } else {
        emit(ChatMessagesSuccess(messages: messages));
      }
    });
  }

  // send text message
  Future<void> sendMessage(String chatId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    final tempMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID مؤقت
      text: text,
      senderId: "me",
      senderName: "Me",
      isMe: true,
      messageType: 'text',
      createdAt: DateTime.now(),
    );

    _updateMessagesList(tempMessage);

    final result = await sendMessageUseCase(chatId, text);

    result.fold(
      (error) {
        emit(ChatMessagesError(error));
      },
      (newMessage) {
        if (state is ChatMessagesSuccess) {
          final currentMessages = (state as ChatMessagesSuccess).messages;
          final newList = currentMessages
              .map((m) => m.id == tempMessage.id ? newMessage : m)
              .toList();
          emit(ChatMessagesSuccess(messages: newList));
        }
      },
    );
  }

  // send voice message
  Future<void> sendVoice(String chatId, String filePath) async {
    final tempMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: "",
      senderId: "me",
      senderName: "Me",
      isMe: true,
      messageType: 'voice',
      mediaUrl: filePath,
      createdAt: DateTime.now(),
    );

    _updateMessagesList(tempMessage);
    try {
      final result = await sendMessageUseCase.sendVoice(chatId, filePath);

      result.fold((error) => emit(ChatMessagesError(error)), (newMessage) {
        if (state is ChatMessagesSuccess) {
          final currentMessages = (state as ChatMessagesSuccess).messages;
          final updatedList = currentMessages
              .map((m) => m.id == tempMessage.id ? newMessage : m)
              .toList();
          emit(ChatMessagesSuccess(messages: updatedList));
        }
      });
    } catch (e) {
      emit(ChatMessagesError("فشل إرسال التسجيل الصوتي"));
    }
  }

  // send image
  Future<void> sendImage(String chatId, String imagePath) async {
    // الرسالة المؤقتة عشان الـ UI يظهر فوراً
    final tempMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: "",
      senderId: "me",
      senderName: "Me",
      isMe: true,
      messageType: 'image',
      mediaUrl: imagePath, // المسار المحلي
      createdAt: DateTime.now(),
    );

    _updateMessagesList(tempMessage);

    // النداء على الـ UseCase
    final result = await sendMessageUseCase.sendImage(chatId, imagePath);

    result.fold((error) => emit(ChatMessagesError(error)), (newMessage) {
      if (state is ChatMessagesSuccess) {
        final currentMessages = (state as ChatMessagesSuccess).messages;
        final newList = currentMessages
            .map((m) => m.id == tempMessage.id ? newMessage : m)
            .toList();
        emit(ChatMessagesSuccess(messages: newList));
      }
    });
  }

  // updatelist
  void _updateMessagesList(MessageEntity newMessage) {
    if (state is ChatMessagesSuccess) {
      final currentMessages = (state as ChatMessagesSuccess).messages;

      emit(ChatMessagesSuccess(messages: [newMessage, ...currentMessages]));

      messageController.clear();
    } else {
      emit(ChatMessagesSuccess(messages: [newMessage]));
      messageController.clear();
    }
  }
}
