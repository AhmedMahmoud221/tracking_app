import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:live_tracking/features/feature_chat/data/datasource/get_chat_messages_use_case.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';
import 'package:live_tracking/features/feature_chat/domain/usecase/send_message_use_case.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/cubit/chat_message_cubit_state.dart';


class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetChatMessagesUseCase getChatMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatMessagesCubit(this.getChatMessagesUseCase, this.sendMessageUseCase) : super(ChatMessagesInitial());
  final TextEditingController messageController = TextEditingController();
 
  // fetch chat messages
  Future<void> fetchMessages(String chatId) async {
    emit(ChatMessagesLoading());
    
    final result = await getChatMessagesUseCase(chatId);
    
    result.fold(
      (error) => emit(ChatMessagesError(error)),
      (messages) {
        if (messages.isEmpty) {
          emit(ChatMessagesEmpty());
        } else {
          emit(ChatMessagesSuccess(messages: messages));
        }
      },
    );
  }

  // send text message
  Future<void> sendMessage(String chatId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    
    final result = await sendMessageUseCase(chatId, text); 
    result.fold(
      (error) => emit(ChatMessagesError(error)),
      (newMessage) => _updateMessagesList(newMessage),
    );
  }

  // send voice message
  Future<void> sendVoice(String chatId, String filePath) async {
    try {
      // إرسال الفويز للسيرفر عبر الـ UseCase
      final result = await sendMessageUseCase.sendVoice(chatId, filePath); 
      
      result.fold(
        (error) => emit(ChatMessagesError(error)),
        (newMessage) => _updateMessagesList(newMessage), // استخدمنا الدالة الموحدة للتحديث
      );
    } catch (e) {
      emit(ChatMessagesError("فشل إرسال التسجيل الصوتي"));
    }
  }

  void _updateMessagesList(MessageEntity newMessage) {
    if (state is ChatMessagesSuccess) {
      final currentMessages = (state as ChatMessagesSuccess).messages;
      emit(ChatMessagesSuccess(messages: [...currentMessages, newMessage]));
      messageController.clear();
    }
  }
}