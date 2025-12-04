import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const LogoutButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.logout,
              size: 28,
              color: Colors.redAccent,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
