import 'package:flutter/material.dart';

class ChatAttachmentsSheet extends StatelessWidget {
  const ChatAttachmentsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _AttachmentItem(icon: Icons.camera_alt, label: "Camera"),
          _AttachmentItem(icon: Icons.image, label: "Gallery"),
          _AttachmentItem(icon: Icons.insert_drive_file, label: "File"),
        ],
      ),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AttachmentItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 26,
          child: Icon(icon),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
