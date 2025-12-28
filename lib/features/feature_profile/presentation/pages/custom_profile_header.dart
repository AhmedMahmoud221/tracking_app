import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';
import 'package:live_tracking/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomProfileHeader extends StatefulWidget {
  final UserProfile profile;

  const CustomProfileHeader({super.key, required this.profile});

  @override
  State<CustomProfileHeader> createState() => _CustomProfileHeaderState();
}

class _CustomProfileHeaderState extends State<CustomProfileHeader> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  static const String _prefsKey = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_prefsKey);
    if (path != null && File(path).existsSync()) {
      setState(() {
        _pickedImage = File(path);
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, maxWidth: 600);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, image.path);
    }
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                Text(AppLocalizations.of(context)!.camera),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                Text(AppLocalizations.of(context)!.gallery),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [
                Colors.grey[800]!, // رمادي غامق (البداية)
                Colors.grey[900]!, // رمادي أغمق يقترب من الأسود (النهاية)
              ]
            : [
                const Color.fromARGB(255, 0, 92, 121), // أزرق غامق
                const Color.fromARGB(255, 79, 229, 255), // أزرق فاتح
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
          Stack(
            children: [
              GestureDetector(
                onTap: _showPickOptions,
                child: CircleAvatar(
                  radius: 56,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : const AssetImage(AssetsData.profile) as ImageProvider,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showPickOptions,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: isDark ? Colors.grey[500] : Colors.blue,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.profile.name,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.profile.email,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.white70,
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
            child: Text(
              AppLocalizations.of(context)!.editprofile,
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
