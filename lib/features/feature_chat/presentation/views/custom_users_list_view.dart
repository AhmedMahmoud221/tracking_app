import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_list/chat_list_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_list/chat_list_state.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_message/chat_message_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_socket/chat_socket_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_socket/chat_socket_state.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/chat_messege_screen.dart';
import 'package:live_tracking/l10n/app_localizations.dart';
import 'package:live_tracking/main.dart';

class CustomUsersListView extends StatelessWidget {
  const CustomUsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;   
    final myId = context.read<ChatListCubit>().myId;
    return BlocListener<ChatSocketCubit, ChatSocketState>(
      listener: (context, state) {
        // print("🔔 [Listener Debug] New State Received: $state");
        if (state is ChatSocketMessageReceived) {
        // print('message : ${state.message.text}');
          // في حالة استلام رسالة كاملة (وأنت جوه الشات)
          context.read<ChatListCubit>().updateFromLastMessageEvent({
            'chatId': state.message.chatId,
            'lastMessage': {
              'text': state.message.text,
              'senderId': state.message.senderId,
              'createdAt': state.message.createdAt.toIso8601String(),
              'messageType': state.message.messageType,
            }
          });
        } else if (state is ChatSocketLastMessageUpdate) {
          context.read<ChatListCubit>().updateFromLastMessageEvent(state.data);
        }
      },
      child: BlocBuilder<ChatListCubit, ChatListState>(
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
              return Center(child: Text(AppLocalizations.of(context)!.nochats));
            }

            return ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (context, index) =>
                  const Divider(indent: 85, endIndent: 15, height: 1),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
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
                    (chat.lastMessageSenderId == myId ? "${AppLocalizations.of(context)!.you} : " : "") +
                        chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          (chat.hasUnreadMessages &&
                              chat.lastMessageSenderId != myId)
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color:
                          (chat.hasUnreadMessages &&
                              chat.lastMessageSenderId != myId)
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatChatTime(chat.createdAt),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (chat.hasUnreadMessages &&
                          chat.lastMessageSenderId != myId)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "!",
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
                    context.read<ChatSocketCubit>().markAsRead(chat.chatId);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => sl<ChatMessagesCubit>(),
                          child: ChatMessagesScreen(
                            userName: chat.otherUserName,
                            chatId: chat.chatId,
                          ),
                        ),
                      ),
                    ).then((_) {
                      if (!context.mounted) return;
                      context.read<ChatListCubit>().fetchChats(showLoading: false);
                    });
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }  
}

String formatChatTime(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateToCheck = DateTime(date.year, date.month, date.day);

  if (dateToCheck == today) {
    // لو الرسالة النهاردة: يظهر الوقت فقط (مثال: 10:30 AM)
    return DateFormat('hh:mm a').format(date);
  } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
    // لو الرسالة إمبارح: يظهر كلمة Yesterday
    return "Yesterday";
  } else if (now.difference(dateToCheck).inDays < 7) {
    // لو في خلال الأسبوع الحالي: يظهر اسم اليوم (مثال: Saturday)
    return DateFormat('EEEE').format(date);
  } else {
    // لو أقدم من أسبوع: يظهر التاريخ العادي
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
