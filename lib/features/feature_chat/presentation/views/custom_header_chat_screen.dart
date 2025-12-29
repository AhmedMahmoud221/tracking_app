import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/chat_messege_screen.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/user_profile_screen.dart';

class CustomHeaderChatScreen extends StatelessWidget {
  const CustomHeaderChatScreen({
    super.key,
    required this.widget,
  });

  final ChatMessagesScreen widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserProfileScreen(
              userName: widget.userName,
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
                'https://i.pravatar.cc/150?u=${widget.userName}',
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white),
                fit: BoxFit.cover,
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