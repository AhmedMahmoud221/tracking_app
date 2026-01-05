import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:live_tracking/core/constants/api_constants.dart';

class SocketService {
  IO.Socket? _socket;

  IO.Socket get socket {
    if (_socket == null) {
      init("");
      print("⚠️ Warning: Socket accessed before init, initialized with empty token.");
    }
    return _socket!;
  }

  void init(String token) {
    if (_socket != null && token.isEmpty && _socket!.connected) return;

    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setAuth({'token': token})
          .setQuery({'token': token})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) => print('✅ Socket Connected: ${_socket!.id}'));
    _socket!.onConnectError((data) => print('⚠️ Socket Connect Error: $data'));
  }

  void updateToken(String token) {
     _socket?.io.options?['auth'] = {'token': token};
     _socket?.disconnect().connect();
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
