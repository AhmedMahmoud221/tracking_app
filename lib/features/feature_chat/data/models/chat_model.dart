import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.chatId,
    required super.otherUserName,
    super.profilePicture,
    required super.lastMessage,
    required super.createdAt,
    required super.hasUnreadMessages, 
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final List userIds = json['userIds'] ?? [];
    final Map<String, dynamic> otherUser = userIds.isNotEmpty ? userIds[0] : {};
    
    final lastMsgData = json['lastMessage'];
    bool unread = false;
    String lastMsgText = "";

    if (lastMsgData != null && lastMsgData is Map) {
      unread = lastMsgData['seen'] == false; 
      
      lastMsgText = lastMsgData['content'] ?? 
                    lastMsgData['message'] ?? 
                    "Sent a ${lastMsgData['messageType'] ?? 'message'}";
    } else {
      lastMsgText = "No messages yet";
    }

    return ChatModel(
      chatId: json['_id'] ?? '',
      otherUserName: otherUser['name'] ?? 'Unknown',
      profilePicture: otherUser['profilePicture'],
      lastMessage: lastMsgText,
      hasUnreadMessages: unread, 
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
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