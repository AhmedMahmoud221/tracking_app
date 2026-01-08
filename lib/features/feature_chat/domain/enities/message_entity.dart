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
  final bool isEdited;
  final bool isDeleted;

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
    this.isEdited = false,
    this.isDeleted = false,
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
      'isEdited': isEdited,
      'isDeleted': isDeleted,
    };
  }

  MessageEntity copyWith({
    String? text,
    bool? isEdited,
    bool? isDeleted,
  }) {
    return MessageEntity(
      id: id,
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      senderImage: senderImage,
      text: text ?? this.text,
      messageType: messageType,
      mediaUrl: mediaUrl,
      fileName: fileName,
      createdAt: createdAt,
      isMe: isMe,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}