import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_list/chat_list_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/custom_searchbar_users_list.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/custom_users_list_view.dart';
import 'package:live_tracking/injection_container.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<ChatListCubit>()..fetchChats(),
      child: Scaffold(
        // floating action button to create new chat
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          onPressed: () => _showCreateChatSheet(context),
        ),
        // header and chat list
        body: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomSearchbarUsersList(isDark: isDark),
              ),

              // Chat List
              Expanded(child: CustomUsersListView()),
            ],
          ),
        ),
      ),
    );
  }
}

void _showCreateChatSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ليأخذ مساحة المحتوى فقط
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: isDark ? Colors.white70 : Colors.blue[400],
                child: Icon(
                  Icons.person,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
              title: Text(
                "Private Chat",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                "Chat with a single person",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // انتقل لصفحة اختيار مستخدم واحد
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: isDark ? Colors.white70 : Colors.blue[400],
                child: Icon(
                  Icons.group,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
              title: Text(
                "Group Chat",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                "Create a group with multiple people",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // انتقل لصفحة إنشاء جروب
              },
            ),
          ],
        ),
      );
    },
  );
}
