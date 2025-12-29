class MessageEntity {
  final String id;
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
}