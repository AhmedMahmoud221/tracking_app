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

  factory MessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    final sender = json['senderId'];
    final sId = sender is Map ? sender['_id'] : sender;

    return MessageModel(
      id: json['_id'],
      senderId: sId,
      senderName: sender is Map ? sender['name'] : '',
      senderImage: sender is Map ? sender['profilePicture'] : null,
      text: json['text'] ?? '',
      messageType: json['messageType'] ?? 'text',
      mediaUrl: json['mediaUrl'],
      fileName: json['fileName'],
      createdAt: DateTime.parse(json['createdAt']),
      isMe: sId == currentUserId, 
    );
  }
}