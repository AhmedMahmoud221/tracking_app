import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/chat_messege_screen.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class UserProfileScreen extends StatelessWidget {
  // final String userName;
  final ChatMessagesScreen widget;

  const UserProfileScreen({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;   
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar
          SliverAppBar(
            actions: [
              // Navigate IconButton to PopupMenuButton
              PopupMenuButton<String>(
                offset: const Offset(0, 45),
                color: isDark ? Colors.grey[800] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                icon: Icon(Icons.more_vert, color: isDark ? Colors.white : Colors.white,),
                onSelected: (value) {
                  switch (value) {
                    case 'block':
                      print("Block clicked");
                      break;  
                  }
                },
                
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'block',
                    child: ListTile(
                      leading: Icon(Icons.block, color: Colors.red, size: 20),
                      title: Text(AppLocalizations.of(context)!.block, style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],

            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.userName, style: TextStyle(color: isDark ? Colors.grey[200] : Colors.white),),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://i.pravatar.cc/150?u=${widget.userName}',
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),

          // Items with user info
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                _infoTile(Icons.phone, AppLocalizations.of(context)!.phone, "0123456789"),
                _infoTile(Icons.email, AppLocalizations.of(context)!.email, "user@mail.com"),
                _infoTile(Icons.info, AppLocalizations.of(context)!.about, "CEO at Example Inc."),
                const SizedBox(height: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
