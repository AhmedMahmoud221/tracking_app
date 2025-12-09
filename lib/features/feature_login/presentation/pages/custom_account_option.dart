import 'package:flutter/material.dart';
import 'package:live_tracking/core/utils/styles.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text1,
          style: Styles.textStyle16.copyWith(
            color: Colors.black54.withValues(alpha:  0.3),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            text2,
            style: Styles.textStyle16.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
