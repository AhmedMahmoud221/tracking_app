import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/chat_list_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/chat_list_state.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/cubit/chat_message_cubit_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/chat_messege_screen.dart';
import 'package:live_tracking/main.dart';

class CustomUsersListView extends StatelessWidget {
  const CustomUsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        if (state is ChatListLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatListError) {
          return Center(child: Text(state.message));
        }

        if (state is ChatListSuccess) {
          final chats = state.chats;

          if (chats.isEmpty) {
            return const Center(child: Text("No chats yet."));
          }

          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (context, index) =>
                const Divider(indent: 85, endIndent: 15, height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  backgroundImage:
                      chat.profilePicture != null &&
                          chat.profilePicture!.isNotEmpty
                      ? NetworkImage(chat.profilePicture!)
                      : null,
                  child:
                      chat.profilePicture == null ||
                          chat.profilePicture!.isEmpty
                      ? Text(
                          chat.otherUserName.isNotEmpty
                              ? chat.otherUserName[0]
                              : "?",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                title: Text(
                  chat.otherUserName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: chat.hasUnreadMessages
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: chat.hasUnreadMessages ? Colors.black : Colors.grey,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatChatTime(chat.createdAt), // استخدام الدالة الذكية
                      style: TextStyle(
                        color: Theme.of(context).primaryColor, // لون مميز للوقت
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // دائرة الإشعار (تظهر فقط لو فيه رسائل غير مقروءة)
                    if (chat.hasUnreadMessages)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          "1", // مؤقتاً هنعرض 1، أو لو عندك count حقيقي حطه هنا
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => sl<ChatMessagesCubit>(),
                        child: ChatMessagesScreen(
                          userName: chat.otherUserName, // مرر الاسم هنا
                          chatId: chat.chatId, // مرر الـ ID هنا
                        ),
                      ),
                    ),
                  ).then((_) {
                    context.read()<ChatListCubit>().fetchChats();
                  });
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

String formatChatTime(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateToCheck = DateTime(date.year, date.month, date.day);

  if (dateToCheck == today) {
    // لو النهاردة: يظهر الوقت 10:30 AM
    return DateFormat('hh:mm a').format(date);
  } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
    // لو إمبارح: يظهر كلمة Yesterday
    return "Yesterday";
  } else {
    // لو أقدم: يظهر التاريخ 29/12/2025
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
