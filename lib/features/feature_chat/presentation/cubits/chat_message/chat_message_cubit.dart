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

        // 1. فحص هل السوكيت سبقنا وضاف الرسالة؟
        bool alreadyAddedBySocket = currentMessages.any(
          (m) => m.id == newMessage.id,
        );

        List<MessageEntity> newList;
        if (alreadyAddedBySocket) {
          // لو موجودة، بنشيل الـ temp اللي كنا ضايفينها بس
          newList = currentMessages
              .where((m) => m.id != tempMessage.id)
              .toList();
        } else {
          // لو مش موجودة، بنبدل الـ temp بالحقيقية
          newList = currentMessages
              .map((m) => m.id == tempMessage.id ? newMessage : m)
              .toList();
        }

        // 2. الترتيب (الخطوة السحرية عشان الترتيب ما يبوظش لما تقفل وتفتح)
        // بنرتب بحيث الأحدث (createdAt الأكبر) يكون هو اللي في الأول (index 0)
        newList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // 3. إرسال الحالة النهائية مرة واحدة فقط
        emit(ChatMessagesSuccess(messages: newList));
      }
    });
  }

  //============================================================================
  // fetch chat messages
  Future<void> fetchMessages(String chatId, String currentUserId) async {
    emit(ChatMessagesLoading());

    print("CUBIT RECEIVED ID: $currentUserId");

    final result = await getChatMessagesUseCase(chatId);
    result.fold((error) => emit(ChatMessagesError(error)), (messagesList) {
      final messages = messagesList
          .map((e) => MessageModel.fromJson(e.toJson(), currentUserId))
          .toList()
          .reversed
          .toList(); // ✅ ضيفنا العكس هنا

      emit(ChatMessagesSuccess(messages: messages));
    });
  }

  // show messages from socket
  void addIncomingMessageFromSocket(MessageModel newMessage) {
    final currentState = state;
    if (currentState is ChatMessagesSuccess) {
      // 1. فحص هل الرسالة موجودة فعلاً (عشان ما نكررهاش لو السوكيت بعتها مرتين)
      bool existsById = currentState.messages.any((m) => m.id == newMessage.id);

      // 2. فحص هل دي رسالة "أنا" اللي بعتها ولسه ظاهرة كـ Temp؟
      bool isMyOwnTempMessage = currentState.messages.any(
        (m) => m.text == newMessage.text && m.isMe == true && m.id.length > 15,
      );

      if (!existsById && !isMyOwnTempMessage) {
        final updatedList = List<MessageEntity>.from(currentState.messages)
          ..insert(0, newMessage); // إضافة الرسالة في أول القائمة

        emit(ChatMessagesSuccess(messages: updatedList));
        print("✅ Socket: New Object Message Added");
      } else {
        print("⚠️ Socket: Message ignored (Duplicate or My own temp)");
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
