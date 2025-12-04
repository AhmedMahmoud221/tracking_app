import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildItem(Icons.home, "Home", 0),
          buildItem(Icons.devices, "Devices", 1),
          buildItem(Icons.gps_fixed, "Live", 2),
          buildItem(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget buildItem(IconData icon, String label, int index) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20 : 16,
          vertical: isActive ? 10 : 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 250),
              scale: isActive ? 1.3 : 1.0,
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: isActive ? Colors.blue : Colors.grey,
                size: 26,
              ),
            ),

            // مسافة بين الأيقونة والليبل
            if (isActive)
              AnimatedSlide(
                duration: const Duration(milliseconds: 280),
                offset: isActive ? const Offset(0, 0) : const Offset(0.3, 0),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: isActive ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}