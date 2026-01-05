import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/socketService/socket_service.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_chat/data/models/message_model.dart';
import 'chat_socket_state.dart';

class ChatSocketCubit extends Cubit<ChatSocketState> {
  final SocketService _socketService;

  ChatSocketCubit(this._socketService) : super(ChatSocketInitial());

  void connectToChat(String chatId) {
    _socketService.socket.off('new-message');

    _socketService.socket.emit('join-chat', chatId);

    markAsRead(chatId);

    _socketService.socket.on('new-message', (data) async {
      if (!isClosed) {
        final myId = await SecureStorage.readUserId();
        final message = MessageModel.fromJson(data, myId ?? "");
        emit(ChatSocketMessageReceived(message));
        // print("✅ New message emitted to UI: $data");
      }
    });
  }

  void disconnectFromChat(String chatId) {
    _socketService.socket.emit('leave-chat', chatId);
    _socketService.socket.off('new-message');
  }

  @override
  Future<void> close() {
    _socketService.socket.off('new-message');
    return super.close();
  }

  void initSocket() {
    _socketService.socket.connect();

    _socketService.socket.on('message', (data) async {
      final myId = await SecureStorage.readUserId(); 
      // print("New Message Received via Socket: $data");
      final message = MessageModel.fromJson(data, myId ?? "");
      emit(ChatSocketMessageReceived(message));
      // print("📩 Global Socket Message Received: ${message.text}");
    });
  }

  void markAsRead(String chatId) async {
    try {
      final myId = await SecureStorage.readUserId();

      if (_socketService.socket.connected) {
        _socketService.socket.emit('markAsSeen', {
          'chatId': chatId,
          'senderId': myId,
        });

        // print("✅ Sent markAsSeen for chat: $chatId by user: $myId");
      }
    } catch (e) {
      // print("❌ Error in markAsRead Socket: $e");
    }
  }
}
