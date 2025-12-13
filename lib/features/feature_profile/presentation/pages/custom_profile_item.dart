import 'package:flutter/material.dart';

class CustomProfileitems extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CustomProfileitems({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isDark
                  ? Colors.white
                  : const Color.fromARGB(255, 0, 92, 121),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: isDark ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
