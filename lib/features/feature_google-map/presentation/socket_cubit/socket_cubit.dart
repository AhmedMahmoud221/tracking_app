import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/features/feature_google-map/presentation/socket_cubit/socket_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketCubit extends Cubit<SocketState> {
  // 💡 نقل كائن الـ Socket إلى هنا
  late IO.Socket _socket;

  // 🎯 Constructor لا يحتاج لـ SocketService الآن
  SocketCubit() : super(SocketInitial());

  void connect(String token) {
    // 1. إنشاء كائن الـ Socket وتهيئته هنا مباشرة
    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket.connect();

    // 2. تسجيل المستمعين مباشرة على كائن _socket
    _socket.onConnect((_) {
      // print('✅ Socket Connected');
      emit(SocketConnected());
      //joinTrackingRoom();
    });

    _socket.onDisconnect((_) {
      // print('❌ Socket Disconnected');
    });

    _socket.on('joined', (data) {
      // print('Joined device room $data');
    });

    // 3. الاستماع لـ 'device:live' وتوجيه الحالة
    _socket.on('device:live', (data) {
      // print('New location: $data');
      emit(SocketLocationUpdated(data));
    });
  }

  @override
  Future<void> close() {
    // 5. التصرف في الـ Socket
    _socket.disconnect();
    _socket.dispose();
    return super.close();
  }
}
