import 'package:flutter/material.dart';
import 'package:live_tracking/core/utils/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  final String buttonText;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 36, 167, 255),
          borderRadius: BorderRadius.circular(16),
        ),
        width: double.infinity,
        height: 60,
        child: Center(
          child: Text(
            buttonText,
            style: Styles.textStyle20.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
