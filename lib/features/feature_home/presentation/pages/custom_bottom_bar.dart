import 'package:flutter/material.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

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
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildItem(context, Icons.home, AppLocalizations.of(context)!.home, 0),
          buildItem(
            context,
            Icons.directions_car,
            AppLocalizations.of(context)!.devices,
            1,
          ),
          buildItem(
            context,
            Icons.gps_fixed,
            AppLocalizations.of(context)!.live,
            2,
          ),
          buildItem(
            context,
            Icons.person,
            AppLocalizations.of(context)!.profile,
            3,
          ),
        ],
      ),
    );
  }

  Widget buildItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final bool isActive = currentIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

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
          color: isActive ? Colors.blue[400] : Colors.transparent,
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
                color: isActive
                    ? Colors.white
                    : colorScheme.onSurface.withOpacity(0.5),
                size: 26,
              ),
            ),
            if (isActive) const SizedBox(width: 6),
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
                      style: TextStyle(
                        color: Colors.white,
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
