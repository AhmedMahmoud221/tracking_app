import 'package:live_tracking/core/utils/secure_storage.dart';
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
    required super.email,
    required super.phoneNumber,
    required super.userStatus,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, [String? myId]) {
    final bool isSearchResult = json.containsKey('email') && !json.containsKey('userIds');

    if (isSearchResult) {
      return ChatModel(
        chatId: json['_id'] ?? '',
        otherUserName: json['name'] ?? 'Unknown',
        profilePicture: json['profilePicture'],
        email: json['email'] ?? '',
        phoneNumber: json['phoneNumber'] ?? json['phone'] ?? "",
        userStatus: json['status'] ?? "Offline",
        lastMessage: '',
        hasUnreadMessages: false,
        lastMessageSenderId: '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt']).toLocal()
            : DateTime.now(),
      );
    } else {
      final List userIds = json['userIds'] ?? [];
      final currentUserId = myId ?? SecureStorage.readUserId();

      if (userIds.isEmpty) {
        return ChatModel(
          chatId: json['_id'] ?? '',
          otherUserName: 'Unknown User',
          lastMessage: '',
          email: '',
          phoneNumber: '',
          userStatus: "Offline",
          hasUnreadMessages: false,
          lastMessageSenderId: '',
          createdAt: DateTime.now(),
        );
      }

      final otherUser = userIds.firstWhere(
        (user) => user['_id'].toString() != currentUserId,
        orElse: () => userIds[0],
      );

      final String extractedStatus = otherUser['status'] ?? "Offline";
      final String extractedEmail = otherUser['email'] ?? '';
      final String extractedPhone = otherUser['phoneNumber'] ?? otherUser['phone'] ?? "";

      final lastMsgData = json['lastMessage'];
      bool unread = false;
      String lastMsgText = "";
      String senderId = "";
      DateTime displayDate = DateTime.now();

      if (lastMsgData != null && lastMsgData is Map) {
        unread = lastMsgData['seen'] == false;
        senderId = lastMsgData['senderId']?.toString() ?? "";
        lastMsgText = lastMsgData['message'] ?? lastMsgData['text'] ?? "Media content";
        if (lastMsgData['createdAt'] != null) {
          displayDate = DateTime.parse(lastMsgData['createdAt']).toLocal();
        }
      }

      return ChatModel(
        chatId: json['_id'] ?? '',
        otherUserName: otherUser['name'] ?? 'Unknown',
        profilePicture: otherUser['profilePicture'],
        email: extractedEmail,
        phoneNumber: extractedPhone,
        userStatus: extractedStatus,
        lastMessage: lastMsgText,
        hasUnreadMessages: unread,
        lastMessageSenderId: senderId,
        createdAt: displayDate,
      );
    }
  }
}

class ChatResponseModel {
  final List<ChatModel> chats;

  ChatResponseModel({required this.chats});

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] != null && json['data']['chats'] != null 
               ? json['data']['chats'] as List 
               : [];
               
    return ChatResponseModel(
      chats: list.map((i) => ChatModel.fromJson(i)).toList(),
    );
  }
}