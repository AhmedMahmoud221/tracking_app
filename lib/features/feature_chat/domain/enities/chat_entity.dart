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
}
