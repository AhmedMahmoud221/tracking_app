abstract class ChatSocketState {}

class ChatSocketInitial extends ChatSocketState {}

class ChatSocketMessageReceived extends ChatSocketState {
  final dynamic data; // البيانات الخام اللي جاية من السيرفر
  ChatSocketMessageReceived(this.data);
}
