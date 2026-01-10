import 'package:flutter/material.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/chat_messege_screen.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/user_profile_screen.dart';

class CustomHeaderChatScreen extends StatelessWidget {
  const CustomHeaderChatScreen({super.key, required this.widget});

  final ChatMessagesScreen widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserProfileScreen(
              widget: widget,
              chat: ChatEntity(
                // بنعمل كائن مؤقت بالبيانات اللي معانا
                chatId: widget.chatId,
                otherUserName: widget.userName,
                profilePicture: widget.profilePicture, // تمرير الصورة هنا
                email: widget.email, // لو مش معاك الايميل هنا سيبه فاضي
                lastMessage: "",
                createdAt: DateTime.now(),
                hasUnreadMessages: false,
                lastMessageSenderId: "",
                phoneNumber: widget.phoneNumber,
                userStatus: widget.userStatus,
              ),
            ),
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[300],
            child: ClipOval(
              child: Image.network(
                _getFormattedUrl(widget.profilePicture),
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, color: Colors.white),
                fit: BoxFit.cover,
                width: 36,
                height: 36,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(widget.userName, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

String _getFormattedUrl(String? path) {
  if (path == null || path.isEmpty) return 'https://i.pravatar.cc/150';
  if (path.startsWith('http')) return path;
  return "${ApiConstants.baseUrl}/${path.startsWith('/') ? path.substring(1) : path}";
}
