import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_list/chat_list_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_list/chat_list_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      leading: const SizedBox(width: 48),
      title: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Live ',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'Tracking',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor: isDark ? Colors.black : Colors.white,
      scrolledUnderElevation: 0,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,

      actions: [
        BlocBuilder<ChatListCubit, ChatListState>(
          builder: (context, state) {
            bool hasUnread = false;
            
            if (state is ChatListSuccess) {
              print("Check unread: ${state.chats.map((e) => e.hasUnreadMessages)}");
              hasUnread = state.chats.any((chat) => chat.hasUnreadMessages);
            }
            print("AppBar UI is Rebuilding! hasUnread: $hasUnread");
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_active,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    // Navigator
                  },
                ),
                // blue circel
                if (hasUnread)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 12,
                      height: 12,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue, // الدايرة الزرقاء
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.blue : Colors.black,
                          width: 2,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}