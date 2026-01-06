import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_chat/data/datasource/get_chat_messages_use_case.dart';
import 'package:live_tracking/features/feature_chat/data/models/message_model.dart';
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
      SendMessageParams(chatId: chatId, messageType: 'audio', mediaPath: path),
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
    final myId = await SecureStorage.readUserId() ?? "";

    final tempMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID مؤقت
      chatId: myId,
      text: params.text ?? "",
      senderId: myId,
      senderName: "Me",
      isMe: true,
      messageType: params.messageType,
      mediaUrl: params.mediaPath,
      createdAt: DateTime.now(),
    );

    _updateMessagesList(tempMessage);

    final result = await sendMessageUseCase(params);

    result.fold((error) => emit(ChatMessagesError(error)), (newMessage) {
      if (state is ChatMessagesSuccess) {
        final currentMessages = (state as ChatMessagesSuccess).messages;

        bool alreadyAddedBySocket = currentMessages.any(
          (m) => m.id == newMessage.id,
        );

        List<MessageEntity> newList;
        if (alreadyAddedBySocket) {
          newList = currentMessages
              .where((m) => m.id != tempMessage.id)
              .toList();
        } else {
          newList = currentMessages
              .map((m) => m.id == tempMessage.id ? newMessage : m)
              .toList();
        }


        newList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        emit(ChatMessagesSuccess(messages: newList));
      }
    });
  }

  //============================================================================
  // fetch chat messages
  Future<void> fetchMessages(String chatId, String currentUserId) async {
    emit(ChatMessagesLoading());

    // print("CUBIT RECEIVED ID: $currentUserId");

    final result = await getChatMessagesUseCase(chatId);
    result.fold((error) => emit(ChatMessagesError(error)), (messagesList) {
      final messages = messagesList
          .map((e) => MessageModel.fromJson(e.toJson(), currentUserId))
          .toList()
          .reversed
          .toList(); 

      emit(ChatMessagesSuccess(messages: messages));
    });
  }

  // show messages from socket
  void addIncomingMessageFromSocket(MessageModel newMessage) {
    final currentState = state;
      if (currentState is ChatMessagesSuccess) {
        final updatedList = List<MessageEntity>.from(currentState.messages);

        // 1. ابحث أولاً بالـ ID (لو الرسالة موجودة فعلاً لتجنب التكرار)
        int existingIndex = updatedList.indexWhere((m) => m.id == newMessage.id);

        if (existingIndex != -1) {
          updatedList[existingIndex] = newMessage;
          print("🔄 Socket: Message updated by ID");
        } else {
          // 2. لو مش موجودة، ابحث عن الرسالة المؤقتة اللي أنا بعتها
          // هنقارن بـ (النص) "أو" (اسم الملف) عشان نغطي الصور والملفات
          int tempMessageIndex = updatedList.indexWhere((m) {
            bool isTemp = m.id.length < 10; // الرسائل المؤقتة عادة الـ ID بتاعها قصير أو UUID مختلف
            bool sameText = (m.text == newMessage.text && m.text.isNotEmpty);
            bool sameFile = (m.fileName == newMessage.fileName && m.fileName != null);
            
            return isTemp && m.isMe && (sameText || sameFile);
          });

          if (tempMessageIndex != -1) {
            updatedList[tempMessageIndex] = newMessage;
            print("✅ Socket: Temp message replaced successfully");
          } else {
            // 3. رسالة جديدة تماماً (أو من الشخص الآخر)
            updatedList.insert(0, newMessage);
            print("✅ Socket: New message inserted at index 0");
          }
        }

        // أهم سطر: إصدار الحالة الجديدة لتحديث الـ UI والـ Last Message
        emit(ChatMessagesSuccess(messages: updatedList));
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
