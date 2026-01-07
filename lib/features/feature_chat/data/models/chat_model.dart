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
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
  // 1. أول خطوة: هل ده مستخدم من البحث؟ 
  // بنعرفه بإن الـ Root فيه email أو ميهوش userIds
  final bool isSearchResult = json.containsKey('email') && !json.containsKey('userIds');

  if (isSearchResult) {
    return ChatModel(
      chatId: json['_id'] ?? '',
      otherUserName: json['name'] ?? 'Unknown',
      profilePicture: json['profilePicture'],
      email: json['email'] ?? '',
      lastMessage: '', 
      hasUnreadMessages: false,
      lastMessageSenderId: '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']).toLocal() 
          : DateTime.now(),
    );
  }

  // 2. لو مش بحث، يبقى محادثة عادية (Inbox)
  // هنا بس نبدأ نعرف المتغيرات الخاصة بالمحادثة
  final List userIds = json['userIds'] ?? [];
  
  // حماية إضافية لو القائمة جات فاضية من السيرفر لأي سبب
  if (userIds.isEmpty) {
    return ChatModel(
      chatId: json['_id'] ?? '',
      otherUserName: 'Unknown User',
      lastMessage: '',
      email: '',
      hasUnreadMessages: false,
      lastMessageSenderId: '',
      createdAt: DateTime.now(),
    );
  }

  // الآن نقدر ننفذ الـ Logic بتاع الـ Inbox بأمان
  final myId = SecureStorage.readUserId(); // تأكد إنها مش Future هنا أو ابعتها كـ Parameter
  
  final otherUser = userIds.firstWhere(
    (user) => user['_id'].toString() != myId.toString(),
    orElse: () => userIds[0],
  );

  final String extractedEmail = otherUser['email'] ?? '';
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
