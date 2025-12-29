import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/chat_list_cubit.dart';

class CustomSearchbarUsersList extends StatelessWidget {
  const CustomSearchbarUsersList({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        context.read<ChatListCubit>().searchChats(value);
      },
      decoration: InputDecoration(
        hintText: "Search...",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.blue),
        filled: true,
        fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}