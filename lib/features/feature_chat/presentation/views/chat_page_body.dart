import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/chat_list_screen.dart';

class ChatPageBody extends StatelessWidget {
  const ChatPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChatListScreen(),
    );
  }
}