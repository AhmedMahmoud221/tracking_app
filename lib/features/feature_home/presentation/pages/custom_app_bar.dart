import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(179, 214, 246, 255),
      title: Center(
        child: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
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
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      centerTitle: true,
    );
  }
   @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}