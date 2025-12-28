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
  String? _currentUserName;
  final ImagePicker _picker = ImagePicker();
  
  static const String _imgKey = 'profile_image_path';
  static const String _nameKey = 'profile_username';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserName = prefs.getString(_nameKey) ?? widget.profile.name;
      final path = prefs.getString(_imgKey);
      if (path != null && File(path).existsSync()) {
        _pickedImage = File(path);
      }
    });
  }

  // دالة تعديل الاسم مع الـ Validation
  Future<void> _editUserName() async {
    final TextEditingController controller = TextEditingController(text: _currentUserName);
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    final locale = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          locale.editprofile,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),

        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // هياخد 80% من عرض الشاشة
          child: Form(
            key: _dialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // عشان مياخدش طول الشاشة كلها
              children: [
                TextFormField(
                  controller: controller,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: locale.username,
                    hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                    filled: true,
                    fillColor: isDark ? Colors.white10 : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                      ),
                  ),
                  // --- الـ Validation هنا ---
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return locale.required; // لو الاسم فاضي
                    }
                    if (value.trim().length < 3) {
                      return "Min 3 characters"; // لو أقل من 3 حروف
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              locale.cancel,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // خلفية زرقاء للبوتون في اللايت مود
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white, // لون نص البوتون
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (_dialogFormKey.currentState!.validate()) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString(_nameKey, controller.text.trim());
                
                setState(() {
                  _currentUserName = controller.text.trim();
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Updated!")),
                );
              }
            },
            child: Text(locale.edit),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, maxWidth: 600);
    if (image != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_imgKey, image.path);
      setState(() {
        _pickedImage = File(image.path);
      });
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
    final locale = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [Colors.grey[800]!, Colors.grey[900]!]
            : [const Color(0xFF005C79), const Color(0xFF4FE5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
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
                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _currentUserName ?? widget.profile.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.profile.email,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: _editUserName, // تشغيل التعديل
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                locale.editprofile,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}