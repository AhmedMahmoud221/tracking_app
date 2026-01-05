import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
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
    
    final data = json.containsKey('message') ? json['message'] : json;
    
    // final activeId = (myId.isEmpty) ? "6935eccd50c25daeb0dea0b5" : myId;

    String sId = "";
    String sName = "User";
    String? sImage;

    final senderData = data['senderId'];

    if (senderData is Map) {
      sId = senderData['_id']?.toString() ?? "";
      sName = senderData['name']?.toString() ?? "User";
      sImage = senderData['profilePicture']?.toString();
    } else {
      sId = senderData?.toString() ?? "";
      // sName = data['senderName']?.toString() ?? "User";
    }

    // 4. معالجة التاريخ
    DateTime parsedDate;
    try {
      parsedDate = data['createdAt'] != null 
          ? DateTime.parse(data['createdAt']) 
          : DateTime.now();
    } catch (e) {
      parsedDate = DateTime.now();
    }

    // السطر السحري اللي بيحدد يمين ولا شمال
    bool checkIsMe = (sId == myId);

    // print("DEBUG: sId: '$sId' | activeId: '$activeId' | Final isMe: $checkIsMe");

    String textContent = "";
    if (data['content'] != null) {
      textContent = data['content'].toString();
    } else if (data['text'] != null) {
      textContent = data['text'].toString();
    } else if (json['message'] is String) {
      // أحياناً السيرفر بيبعت الرسالة كـ String مباشرة في حقل message
      textContent = json['message'].toString();
    }

    return MessageModel(
      id: data['_id']?.toString() ?? "",
      senderId: sId,
      senderName: sName,
      senderImage: sImage,
      text: textContent,
      // text: data['message']?.toString() ?? data['text']?.toString() ?? "",
      messageType: data['messageType']?.toString() ?? "text",
      mediaUrl: data['mediaUrl']?.toString(),
      fileName: data['fileName']?.toString(),
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
      'createdAt': createdAt.toIso8601String(),
    };
  }
}