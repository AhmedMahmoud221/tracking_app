import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/socketService/socket_service.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_chat/data/models/message_model.dart';
import 'chat_socket_state.dart';

class ChatSocketCubit extends Cubit<ChatSocketState> {
  final SocketService _socketService;
  // String? currentUserId;

  ChatSocketCubit(this._socketService) : super(ChatSocketInitial());

  // الدخول لغرفة الشات والاستماع للرسائل
  void connectToChat(String chatId) {
    // 1. تأمين: شيل أي مستمع قديم للحدث ده عشان الداتا متتكررش
    _socketService.socket.off('new-message');

    // 2. الانضمام للروم (تأكد من اسم الـ event من الـ Backend)
    _socketService.socket.emit('join-chat', chatId);

    markAsRead(chatId);

    // 3. الاستماع للرسائل الجديدة
    _socketService.socket.on('new-message', (data) async {
      if (!isClosed) {
        final myId = await SecureStorage.readUserId();
        // تحويل الداتا لموديل قبل الـ emit
        final message = MessageModel.fromJson(data, myId ?? "");
        emit(ChatSocketMessageReceived(message));
        print("✅ New message emitted to UI: $data");
      }
    });
  }

  // الخروج من الغرفة وتنظيف المستمعين
  void disconnectFromChat(String chatId) {
    _socketService.socket.emit('leave-chat', chatId);
    _socketService.socket.off('new-message');
  }

  @override
  Future<void> close() {
    // لا نغلق السوكيت هنا لأنه "مشاع" للتطبيق كله، فقط نتوقف عن الاستماع
    _socketService.socket.off('new-message');
    return super.close();
  }

  void initSocket() {
    // استدعاء ميثود الاتصال الموجودة في SocketService
    _socketService.socket.connect();

    // الاستماع للرسائل القادمة
    _socketService.socket.on('message', (data) async {
      final myId = await SecureStorage.readUserId(); // مثال لو عندك ميثود قراءة
      // هنا تضع منطق تحويل البيانات لـ MessageModel عمل Emit للحالة
      print("New Message Received via Socket: $data");
      final message = MessageModel.fromJson(data, myId ?? "");
      emit(ChatSocketMessageReceived(message));
      print("📩 Global Socket Message Received: ${message.text}");
    });
  }

  void markAsRead(String chatId) async {
    try {
      // 1. نجيب الـ ID بتاعنا من الـ Secure Storage
      final myId = await SecureStorage.readUserId();

      if (_socketService.socket.connected) {
        // 2. نرسل الحدث للسيرفر
        // ملاحظة: تأكد من الـ Backend إذا كان اسم الحدث 'markAsSeen' أو 'message-seen'
        _socketService.socket.emit('markAsSeen', {
          'chatId': chatId,
          'senderId': myId,
        });

        print("✅ Sent markAsSeen for chat: $chatId by user: $myId");
      }
    } catch (e) {
      print("❌ Error in markAsRead Socket: $e");
    }
  }
}
