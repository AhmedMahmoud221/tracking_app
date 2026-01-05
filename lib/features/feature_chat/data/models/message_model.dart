import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.chatId,
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

  factory MessageModel.fromJson(Map<String, dynamic> json, String myId) {
    // print("DEBUG SOCKET JSON: $json");
    Map<String, dynamic> body;

    if (json.containsKey('data') && json['data'] is Map && json['data'].containsKey('message')) {
      body = json['data']['message'];
    } else if (json.containsKey('message') && json['message'] is Map) {
      body = json['message'];
    } else {
      body = json;
    }

    String sId = "";
    String sName = "User";
    String? sImage;

    final senderData = body['senderId'];

    if (senderData is Map) {
      sId = senderData['_id']?.toString() ?? "";
      sName = senderData['name']?.toString() ?? "User";
      sImage = senderData['profilePicture']?.toString();
    } else {
      sId = senderData?.toString() ?? "";
    }

    String textContent = body['text']?.toString() ?? 
                         body['content']?.toString() ?? "";
    
    if (textContent.isEmpty && json['message'] is String) {
      textContent = json['message'].toString();
    }

    DateTime parsedDate;
    try {
      parsedDate = body['createdAt'] != null 
          ? DateTime.parse(body['createdAt']) 
          : DateTime.now();
    } catch (e) {
      parsedDate = DateTime.now();
    }

    bool checkIsMe = (sId == myId);

    return MessageModel(
      id: body['_id']?.toString() ?? "",
      chatId: body['chatId']?.toString() ?? "",
      senderId: sId,
      senderName: sName,
      senderImage: sImage,
      text: textContent,
      messageType: body['messageType']?.toString() ?? "text",
      mediaUrl: body['mediaUrl']?.toString(),
      fileName: body['fileName']?.toString(),
      createdAt: parsedDate,
      isMe: checkIsMe,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'messageType': messageType,
      'mediaUrl': mediaUrl,
      'fileName': fileName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}