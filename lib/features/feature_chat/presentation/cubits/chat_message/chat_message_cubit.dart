import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/data/datasource/get_chat_messages_use_case.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';
import 'package:live_tracking/features/feature_chat/domain/usecase/send_message_use_case.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_message/chat_message_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetChatMessagesUseCase getChatMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatMessagesCubit(this.getChatMessagesUseCase, this.sendMessageUseCase)
    : super(ChatMessagesInitial());
  final TextEditingController messageController = TextEditingController();

  // 1. ميثود إرسال النص (تستخدم الـ Params الآن)
  Future<void> sendMessage(String chatId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    await _handleSending(
      SendMessageParams(chatId: chatId, messageType: 'text', text: text),
    );
  }

  // 2. ميثود الفويس
  Future<void> sendVoice(String chatId, String path) async {
    await _handleSending(
      SendMessageParams(chatId: chatId, messageType: 'voice', mediaPath: path),
    );
  }

  // 3. ميثود الصور
  Future<void> sendImage(String chatId, String path) async {
    await _handleSending(
      SendMessageParams(chatId: chatId, messageType: 'image', mediaPath: path),
    );
  }

  // 4. ميثود الفيديو
  Future<void> sendVideo(String chatId, String path) async {
    await _handleSending(
      SendMessageParams(chatId: chatId, messageType: 'video', mediaPath: path),
    );
  }

  // 5. ميثود الملفات
  Future<void> sendFile(String chatId, String path) async {
    await _handleSending(
      SendMessageParams(chatId: chatId, messageType: 'file', mediaPath: path),
    );
  }

  // الـ "ماكينة" اللي بتنفذ الإرسال الفعلي وتحدث الـ UI
  Future<void> _handleSending(SendMessageParams params) async {
    // إنشاء رسالة مؤقتة للـ Optimistic UI
    final tempMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: params.text ?? "",
      senderId: "me",
      senderName: "Me",
      isMe: true,
      messageType: params.messageType,
      mediaUrl: params.mediaPath, // هيظهر محلياً لو مسار موبايل
      createdAt: DateTime.now(),
    );

    _updateMessagesList(tempMessage);

    final result = await sendMessageUseCase(params);

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

  //============================================================================
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

  // show messages from socket
  void addIncomingMessage(MessageEntity message) {
    if (state is ChatMessagesSuccess) {
      final currentState = state as ChatMessagesSuccess;

      bool exists = currentState.messages.any((m) => m.id == message.id);

      if (!exists) {
        final updatedMessages = List<MessageEntity>.from(currentState.messages)
          ..insert(0, message);

        emit(ChatMessagesSuccess(messages: updatedMessages));
      }
    }
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
