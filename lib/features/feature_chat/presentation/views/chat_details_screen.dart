import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/cubit/chat_message_cubit_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/cubit/chat_message_cubit_state.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/chat_bubble.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String chatId;
  final String userName;

  const ChatDetailsScreen({super.key, required this.chatId, required this.userName});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // بدأ تحميل الرسائل فور فتح الشاشة
    context.read<ChatMessagesCubit>().fetchMessages(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userName)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
              builder: (context, state) {
                if (state is ChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatMessagesSuccess) {
                  return ListView.builder(
                    reverse: true, // عشان يبدأ من تحت لأحدث الرسائل
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      // ترتيب الرسائل من الأحدث للأقدم مع reverse
                      final message = state.messages.reversed.toList()[index];
                      return ChatBubble(message: message);
                    },
                  );
                } else if (state is ChatMessagesError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text("Say Hello! 👋"));
              },
            ),
          ),
          _buildMessageInput(), // الجزء بتاع الكتابة
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final cubit = context.read<ChatMessagesCubit>();
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: cubit.messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send, color: Colors.blue), onPressed: () 
          {
            cubit.sendMessage(widget.chatId);
          }),
        ],
      ),
    );
  }
}