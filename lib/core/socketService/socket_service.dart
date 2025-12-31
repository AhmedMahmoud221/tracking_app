import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:live_tracking/core/constants/api_constants.dart';

class SocketService {
  IO.Socket? _socket;

  IO.Socket get socket {
    if (_socket == null) {
      throw Exception("Socket not initialized. Call init() first.");
    }
    return _socket!;
  }

  void init(String token) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) => print('✅ Global Socket Connected'));
    _socket!.onDisconnect((_) => print('❌ Global Socket Disconnected'));
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
