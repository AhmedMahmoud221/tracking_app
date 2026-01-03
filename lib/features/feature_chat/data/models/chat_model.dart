import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.chatId,
    required super.otherUserName,
    super.profilePicture,
    required super.lastMessage,
    required super.createdAt,
    required super.hasUnreadMessages,
    required super.lastMessageSenderId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final List userIds = json['userIds'] ?? [];
    final Map<String, dynamic> otherUser = userIds.isNotEmpty ? userIds[0] : {};
    final lastMsgData = json['lastMessage'];

    bool unread = false;
    String lastMsgText = "";
    String senderId = "";
    DateTime displayDate = DateTime.now();

    if (lastMsgData != null && lastMsgData is Map) {
      unread = lastMsgData['seen'] == false;
      senderId = lastMsgData['senderId']?.toString() ?? "";

      if (lastMsgData['content'] != null &&
          lastMsgData['content'].toString().isNotEmpty) {
        lastMsgText = lastMsgData['content'];
      } else if (lastMsgData['text'] != null &&
          lastMsgData['text'].toString().isNotEmpty) {
        lastMsgText = lastMsgData['text'];
      } else {
        String type = lastMsgData['messageType'] ?? "message";
        lastMsgText = "Sent a $type";
      }

      if (lastMsgData['createdAt'] != null) {
        displayDate = DateTime.parse(lastMsgData['createdAt']).toLocal();
      }
    } else {
      // لو مفيش رسائل خالص، نستخدم تاريخ إنشاء الشات نفسه
      if (json['createdAt'] != null) {
        displayDate = DateTime.parse(json['createdAt']).toLocal();
      }
    }

    return ChatModel(
      chatId: json['_id'] ?? '',
      otherUserName: otherUser['name'] ?? 'Unknown',
      profilePicture: otherUser['profilePicture'],
      lastMessage: lastMsgText,
      hasUnreadMessages: unread,
      lastMessageSenderId: senderId,
      createdAt: displayDate,
    );
  }
}

class ChatResponseModel {
  final List<ChatModel> chats;

  ChatResponseModel({required this.chats});

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      chats: (json['data']['chats'] as List)
          .map((i) => ChatModel.fromJson(i))
          .toList(),
    );
  }
}
