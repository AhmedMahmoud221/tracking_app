import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
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
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
