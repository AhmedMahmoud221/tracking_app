import 'package:flutter/material.dart';

class DotsJumpAnimation extends StatefulWidget {
  const DotsJumpAnimation({super.key});

  @override
  _DotsJumpAnimationState createState() => _DotsJumpAnimationState();
}

class _DotsJumpAnimationState extends State<DotsJumpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double value = (_controller.value + (i * 0.3)) % 1;
              return Transform.translate(
                offset: Offset(0, -10 * Curves.easeOut.transform(value)),
                child: const CircleAvatar(
                  radius: 6,
                  backgroundColor: Color.fromARGB(255, 58, 58, 58),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
