import 'package:live_tracking/features/feature_chat/data/models/message_model.dart';

class MessageResponseModel {
  final List<MessageModel> messages;
  final int total;

  MessageResponseModel({required this.messages, required this.total});

  factory MessageResponseModel.fromJson(Map<String, dynamic> json, String myId) {
    return MessageResponseModel(
      total: json['data']['pagination']['total'] ?? 0,
      messages: (json['data']['messages'] as List)
          .map((m) => MessageModel.fromJson(m, myId))
          .toList(),
    );
  }
}