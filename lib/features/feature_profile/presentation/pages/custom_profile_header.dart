import 'package:flutter/material.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';

class CustomProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const CustomProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 92, 121),
            Color.fromARGB(255, 79, 229, 255),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 56,
            backgroundImage: AssetImage(AssetsData.profile),
          ),
          const SizedBox(height: 15),
          Text(
            profile.name,
            style: TextStyle(
              color: isDark ? Colors.black : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            profile.email,
            style: TextStyle(
              color: isDark ? Colors.black54 : Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
