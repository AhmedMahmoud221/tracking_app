import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/core/utils/styles.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class CustomAccountOption extends StatelessWidget {
  const CustomAccountOption({
    super.key,
    required this.text1,
    required this.text2,
    required this.onPressed,
  });

  final String text1;
  final String text2;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text1,
          style: Styles.textStyle16.copyWith(
            color: isDark ? Colors.white70 : Colors.black54.withValues(alpha: 0.3),
            fontSize: 12,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            text2,
            style: Styles.textStyle16.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kForgotPassword);
          },
          child: Text(
            AppLocalizations.of(context)!.forgetpassword,
            style: Styles.textStyle14.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
