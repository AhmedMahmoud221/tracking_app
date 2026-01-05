import 'package:live_tracking/features/feature_chat/data/models/message_model.dart';

abstract class ChatSocketState {}

class ChatSocketInitial extends ChatSocketState {}

class ChatSocketMessageReceived extends ChatSocketState {
  final MessageModel message; // البيانات الخام اللي جاية من السيرفر
  ChatSocketMessageReceived(this.message);
}

class ChatSocketLastMessageUpdate extends ChatSocketState {
  final Map<String, dynamic> data;
  ChatSocketLastMessageUpdate(this.data);
}
