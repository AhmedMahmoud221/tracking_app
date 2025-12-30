abstract class MapSocketState {}

// 1. الحالة الابتدائية: قبل محاولة الاتصال
class MapSocketInitial extends MapSocketState {}

// 2. حالة الاتصال الجاري: (اختياري، لكن يفضل إضافتها لتظهر Loading UI)
class MapSocketConnecting extends MapSocketState {}

// 3. حالة الاتصال الناجح: يتم إطلاقها بعد onConnect
class MapSocketConnected extends MapSocketState {}

// 4. حالة قطع الاتصال: يتم إطلاقها بعد onDisconnect
class MapSocketDisconnected extends MapSocketState {}

// 5. حالة تحديث الموقع: تحمل بيانات الموقع الجديدة
class MapSocketLocationUpdated extends MapSocketState {
  final dynamic data;
  MapSocketLocationUpdated(this.data);
}

// 6. حالة الخطأ: للتعامل مع أي مشكلة في الاتصال
class MapSocketError extends MapSocketState {
  final String message;
  MapSocketError(this.message);
}
