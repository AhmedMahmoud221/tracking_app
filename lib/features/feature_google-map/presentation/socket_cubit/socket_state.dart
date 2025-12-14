abstract class SocketState {}

// 1. الحالة الابتدائية: قبل محاولة الاتصال
class SocketInitial extends SocketState {}

// 2. حالة الاتصال الجاري: (اختياري، لكن يفضل إضافتها لتظهر Loading UI)
class SocketConnecting extends SocketState {}

// 3. حالة الاتصال الناجح: يتم إطلاقها بعد onConnect
class SocketConnected extends SocketState {} 

// 4. حالة قطع الاتصال: يتم إطلاقها بعد onDisconnect
class SocketDisconnected extends SocketState {}

// 5. حالة تحديث الموقع: تحمل بيانات الموقع الجديدة
class SocketLocationUpdated extends SocketState {
  final dynamic data;
  SocketLocationUpdated(this.data);
}

// 6. حالة الخطأ: للتعامل مع أي مشكلة في الاتصال
class SocketError extends SocketState {
  final String message;
  SocketError(this.message);
}