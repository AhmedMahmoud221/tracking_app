import 'package:flutter/material.dart';
import 'package:live_tracking/core/utils/styles.dart';

class CustomTextFeildHead extends StatelessWidget {
  const CustomTextFeildHead({
    super.key, required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Styles.textStyle18.copyWith(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}