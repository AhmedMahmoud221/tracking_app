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
    // 1. فك تغليف السوكيت
    final data = json.containsKey('message') ? json['message'] : json;
    
    // 2. تأمين الـ ID (لو فاضي نستخدم الثابت)
    final activeId = (myId.isEmpty) ? "6935eccd50c25daeb0dea0b5" : myId;

    // 3. استخراج بيانات الراسل (senderId) بذكاء
    String sId = "";
    String sName = "User";
    String? sImage;

    final senderData = data['senderId']; // بناخد من data مش من json

    if (senderData is Map) {
      sId = senderData['_id']?.toString() ?? "";
      sName = senderData['name']?.toString() ?? "User";
      sImage = senderData['profile_image']?.toString();
    } else {
      sId = senderData?.toString() ?? "";
      sName = data['senderName']?.toString() ?? "User";
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
    bool checkIsMe = (sId == activeId);

    print("DEBUG: sId: '$sId' | activeId: '$activeId' | Final isMe: $checkIsMe");

    return MessageModel(
      id: data['_id']?.toString() ?? "",
      senderId: sId,
      senderName: sName,
      senderImage: sImage,
      text: data['text']?.toString() ?? (data['content']?.toString() ?? ""), // دعم المسميين
      messageType: data['messageType']?.toString() ?? "text",
      mediaUrl: data['mediaUrl']?.toString(),
      fileName: data['fileName']?.toString(),
      createdAt: parsedDate,
      isMe: checkIsMe, // القيمة النهائية
    );
  }

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