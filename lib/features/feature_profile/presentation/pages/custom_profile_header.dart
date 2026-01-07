import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_profile/domain/entities/user_profile.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class CustomProfileHeader extends StatefulWidget {
  final UserProfile profile;

  const CustomProfileHeader({super.key, required this.profile});

  @override
  State<CustomProfileHeader> createState() => _CustomProfileHeaderState();
}

class _CustomProfileHeaderState extends State<CustomProfileHeader> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _editProfile() async {
    final TextEditingController nameController = TextEditingController(text: widget.profile.name);
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // استخدمنا StatefulBuilder عشان نحدث الصورة جوه الـ Dialog
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(locale.editprofile, textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Form(
                key: dialogFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- اختيار الصورة داخل الـ Dialog ---
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!)
                              : (widget.profile.profilepicture.isNotEmpty 
                                  ? NetworkImage(widget.profile.profilepicture.startsWith('http') 
                                      ? widget.profile.profilepicture 
                                      : '${ApiConstants.baseUrl}${widget.profile.profilepicture}') 
                                  : const AssetImage(AssetsData.profile)) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              // بننادي ميثود اختيار الصورة اللي إحنا كاتبينها
                              await _pickImage(ImageSource.gallery); 
                              setDialogState(() {}); // بنحدث حالة الـ Dialog عشان الصورة تظهر فوراً
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // --- حقل إدخال الاسم ---
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: locale.username,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return locale.required;
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
                child: Text(locale.cancel, style: const TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  if (dialogFormKey.currentState!.validate()) {
                    final cubit = context.read<ProfileDataCubit>();

                    await cubit.updateUserProfile(
                      name: nameController.text.trim(),
                      profilePicture: _pickedImage,
                    );

                    setState(() {
                      _pickedImage = null;
                    });

                    Navigator.pop(context);
                  }
                },
                child: Text(locale.edit, style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CustomProfileHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile.name != oldWidget.profile.name || 
        widget.profile.profilepicture != oldWidget.profile.profilepicture) {
      _pickedImage = null; 
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, maxWidth: 600);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  // void showProfileImage() {
     
  // }

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
                // onTap: ,
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.grey[200], 
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!) 
                      : (widget.profile.profilepicture.isNotEmpty 
                          ? NetworkImage(widget.profile.profilepicture.startsWith('http') 
                              ? widget.profile.profilepicture 
                              : '${ApiConstants.baseUrl}${widget.profile.profilepicture}')
                          : const AssetImage(AssetsData.profile)) as ImageProvider, 
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.profile.name,
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
            onTap: _editProfile, // Edit profile button tap
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