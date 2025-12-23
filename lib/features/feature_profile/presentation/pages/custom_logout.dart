import 'package:flutter/material.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class LogoutButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const LogoutButton({super.key, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // نعرف إذا Dark Mode أو Light Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
              Icons.logout,
              size: 28,
              color: isDark ? Colors.redAccent.shade100 : Colors.redAccent,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
