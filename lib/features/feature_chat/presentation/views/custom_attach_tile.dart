import 'package:flutter/material.dart';

class AttachTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const AttachTile({super.key, 
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
