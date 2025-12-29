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
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 10),
          Text(widget.userName, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}