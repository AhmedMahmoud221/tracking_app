import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/chat_cubit_cubit.dart';
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
