import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/socketService/socket_service.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_chat/data/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'chat_socket_state.dart';

class ChatSocketCubit extends Cubit<ChatSocketState> {
  final SocketService _socketService;

  ChatSocketCubit(this._socketService) : super(ChatSocketInitial()) {
    Future.delayed(Duration.zero, () {
      _establishConnection();
    });
  }

  void _establishConnection() {
    final s = _socketService.socket;

    if (!s.connected) {
      s.connect();
    }

    s.on('lastMessage-updated', (data) {
      if (!isClosed) emit(ChatSocketLastMessageUpdate(data));
    });

    _socketService.socket.connect();

    _socketService.socket.onConnect((_) {
      print("✅ Connected to Socket Server");
    });

    _socketService.socket.on('lastMessage-updated', (data) {
      print("🎯 Socket Received lastMessage-updated: $data");
      if (!isClosed) emit(ChatSocketLastMessageUpdate(data));
    });

    // رادار لمراقبة أي حدث بيحصل
    _socketService.socket.onAny((event, data) {
      print("📡 Radar: $event -> $data");
    });

    _socketService.socket.onDisconnect((_) => print("❌ Socket Disconnected"));
  }

  // 2. الانضمام لكل الغرف (بينادى من الـ ChatListCubit)
  void joinAllChats(List<String> chatIds) {
    if (!_socketService.socket.connected) {
       _socketService.socket.connect();
    }
    for (var id in chatIds) {
      _socketService.socket.emit('join-chat', id);
    }
    print("📡 Socket: Joined ${chatIds.length} rooms successfully.");
  }

  // 3. الاتصال بمحادثة معينة (لما تفتح صفحة الشات من جوه)
  void connectToChat(String chatId) {
    // تنظيف الليسنر القديم عشان ميتكررش
    _socketService.socket.off('new-message');

    _socketService.socket.emit('join-chat', chatId);
    markAsRead(chatId);

    _socketService.socket.on('new-message', (data) async {
      if (!isClosed) {
        final myId = await SecureStorage.readUserId();
        final message = MessageModel.fromJson(data, myId ?? "");
        emit(ChatSocketMessageReceived(message));
      }
    });
  }

  // 4. الخروج من المحادثة
  void disconnectFromChat(String chatId) {
    _socketService.socket.emit('leave-chat', chatId);
    _socketService.socket.off('new-message');
  }

  // 5. تحديث الحالة كمقروء
  void markAsRead(String chatId) async {
    final myId = await SecureStorage.readUserId();
    if (_socketService.socket.connected) {
      _socketService.socket.emit('markAsSeen', {
        'chatId': chatId,
        'senderId': myId,
      });
    }
  }

  @override
  Future<void> close() {
    _socketService.socket.off('new-message');
    _socketService.socket.off('lastMessage-updated');
    return super.close();
  }
}