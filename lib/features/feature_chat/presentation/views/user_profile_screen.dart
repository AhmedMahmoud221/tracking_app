import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final String userName;

  const UserProfileScreen({super.key, required this.userName});

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

                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'block':
                      print("Block clicked");
                      break;  
                  }
                },
                
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'block',
                    child: ListTile(
                      leading: Icon(Icons.block, color: Colors.red, size: 20),
                      title: Text('Block', style: TextStyle(color: Colors.red)),
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
              title: Text(userName),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://via.placeholder.com/400',
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
                _infoTile(Icons.phone, "Phone", "0123456789"),
                _infoTile(Icons.email, "Email", "user@mail.com"),
                _infoTile(Icons.info, "About", "CEO at Example Inc."),
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
