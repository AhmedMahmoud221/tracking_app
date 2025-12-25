// // في ملف SocketCubit.dart

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:live_tracking/features/feature_google-map/data/services/socket_service.dart';
// import 'package:live_tracking/features/feature_google-map/presentation/socket_cubit/socket_state.dart';

// class SocketCubit extends Cubit<SocketState> {
//   final SocketService socketService;

//   // 🎯 1. Constructor نظيف لا يسجل مستمعين (يحل LateInitializationError)
//   SocketCubit(this.socketService) : super(SocketInitial());

//   void connect(String token) {
//     // 2. ابدأ الاتصال (هنا يتم تهيئة socket)
//     socketService.connect(token);

//     // 3. سجل المستمعين هنا (بعد بدء التهيئة)
//     socketService.onConnect((_) {
//       print('✅ Socket Connected');
//       emit(SocketConnected());
//       joinTrackingRoom();
//     });

//     socketService.onDisconnect((_) {
//         print('❌ Socket Disconnected');
//     });

//     socketService.onDeviceLocationUpdate((data) {
//       emit(SocketLocationUpdated(data));
//     });
//   }

//   // 🎯 4. استخدام الدالة العامة socketService.emit (يحل LateInitializationError هنا أيضاً)
//   void joinTrackingRoom( ) {
//     // if (deviceIds.isEmpty) {
//     //   print('⚠️ Cannot join room: Device IDs list is empty.');
//     //   return;
//     // }

//     // ✅ تصحيح: استخدام الدالة العامة
//     socketService.emit('join:device-room',
//       '693693f8c8c7e61c807e0860',
//     );

//     print('🚀 Sent join_room request for devices:');
//   }

//   @override
//   Future<void> close() {
//     socketService.dispose();
//     return super.close();
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
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
      'https://v05j2rv7-3000.euw.devtunnels.ms/',
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

  // void joinTrackingRoom() {
  //   // 4. إرسال البيانات مباشرة باستخدام _socket
  //   if (_socket.connected) {
  //     _socket.emit('join:device-room', '693693f8c8c7e61c807e0860');
  //     print('🚀 Sent join_room request for devices:');
  //   }
  // }

  // void joinTrackingRoom() {
  //   // 4. استخدام الدالة المصححة لإرسال البيانات
  //   sendData('join:device-room', '693693f8c8c7e61c807e0860');
  //   print('🚀 Sent join_room request for devices:');
  // }

  @override
  Future<void> close() {
    // 5. التصرف في الـ Socket
    _socket.disconnect();
    _socket.dispose();
    return super.close();
  }
}
