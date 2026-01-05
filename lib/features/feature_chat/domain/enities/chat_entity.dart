class ChatEntity {
  final String chatId;
  final String otherUserName;
  final String? profilePicture;
  final String lastMessage;
  final DateTime createdAt;
  final bool hasUnreadMessages;
  final String lastMessageSenderId;

  ChatEntity({
    required this.chatId,
    required this.otherUserName,
    this.profilePicture,
    required this.lastMessage,
    required this.createdAt,
    required this.hasUnreadMessages,
    required this.lastMessageSenderId,
  });

  // ميثود تسمح بإنشاء نسخة جديدة مع تعديل بعض القيم فقط
  ChatEntity copyWith({
    String? lastMessage,
    DateTime? createdAt,
    bool? hasUnreadMessages,
    String? lastMessageSenderId,
  }) {
    return ChatEntity(
      chatId: this.chatId, // ثابت
      otherUserName: this.otherUserName, // ثابت
      profilePicture: this.profilePicture, // ثابت
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
    );
  }
}
