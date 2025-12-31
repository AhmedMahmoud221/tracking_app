import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/socketService/socket_service.dart';
import 'chat_socket_state.dart';

class ChatSocketCubit extends Cubit<ChatSocketState> {
  final SocketService _socketService;

  ChatSocketCubit(this._socketService) : super(ChatSocketInitial());

  // الدخول لغرفة الشات والاستماع للرسائل
  void connectToChat(String chatId) {
    // 1. تأمين: شيل أي مستمع قديم للحدث ده عشان الداتا متتكررش
    _socketService.socket.off('new-message');

    // 2. الانضمام للروم (تأكد من اسم الـ event من الـ Backend)
    _socketService.socket.emit('join-chat', chatId);

    // 3. الاستماع للرسائل الجديدة
    _socketService.socket.on('new-message', (data) {
      if (!isClosed) {
        emit(ChatSocketMessageReceived(data));
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
}
