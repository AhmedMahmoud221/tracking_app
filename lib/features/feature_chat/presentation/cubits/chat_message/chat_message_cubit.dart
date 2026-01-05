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
    final myId = await SecureStorage.readUserId() ?? "";

    final tempMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID مؤقت
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
      // 1. فحص الـ ID (الوسيلة الأضمن لمنع التكرار)
      bool existsById = currentState.messages.any((m) => m.id == newMessage.id);

      // 2. إذا كانت الرسالة ليست مكررة بالـ ID
      if (!existsById) {
        // هل هذه الرسالة تخصني أنا (التي أرسلتها للتو)؟ 
        // نتحقق من ذلك عن طريق مطابقة النص وأن الحالة السابقة كانت "Me"
        // مع استبدال الرسالة المؤقتة (التي ليس لها ID حقيقي بعد) بالرسالة الجديدة
        
        final updatedList = List<MessageEntity>.from(currentState.messages);
        
        // ابحث عن الرسالة المؤقتة التي أرسلتها أنا بنفس النص (لو موجودة)
        int tempMessageIndex = updatedList.indexWhere(
          (m) => m.text == newMessage.text && m.isMe && m.id.length < 5 // افترضنا أن الـ Temp ID قصير أو غير موجود
        );

        if (tempMessageIndex != -1 && newMessage.isMe) {
          // تحديث الرسالة المؤقتة ببيانات السيرفر (مثل الـ ID الحقيقي)
          updatedList[tempMessageIndex] = newMessage;
          // print("✅ Socket: Temp message updated with real ID");
        } else {
          // إذا كانت رسالة جديدة تماماً من الطرف الآخر أو مني ولم تكن موجودة
          updatedList.insert(0, newMessage);
          // print("✅ Socket: New message added to list");
        }

        emit(ChatMessagesSuccess(messages: updatedList));
      } else {
        // print("⚠️ Socket: Message already exists (ID duplicate)");
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
