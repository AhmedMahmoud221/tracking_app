class MessageEntity {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String text;
  final String messageType;
  final String? mediaUrl;
  final String? fileName;
  final DateTime createdAt;
  final bool isMe; 

  MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.text,
    required this.messageType,
    this.mediaUrl,
    this.fileName,
    required this.createdAt,
    required this.isMe,
  });

  // داخل ملف message_entity.dart
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'text': text,
      'senderId': senderId,
      'messageType': messageType,
      'mediaUrl': mediaUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}