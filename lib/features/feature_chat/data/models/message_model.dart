import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    super.senderImage,
    required super.text,
    required super.messageType,
    super.mediaUrl,
    super.fileName,
    required super.createdAt,
    required super.isMe,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String myId) {
    return MessageModel(
      id: json['_id'] ?? '',
      senderId: json['senderId']?['_id'] ?? '',
      senderName: json['senderId']?['name'] ?? 'Unknown',
      text: json['text'] ?? '', // التعامل مع الـ null
      messageType: json['messageType'] ?? 'text',
      mediaUrl: json['mediaUrl'], // السيرفر هيبعته لو ميديا
      createdAt: DateTime.parse(json['createdAt']),
      isMe: (json['senderId']?['_id'] ?? '') == myId,
    );
  }
}
