import 'package:flutter/material.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/chat_messege_screen.dart';
import 'package:live_tracking/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatelessWidget {
  final ChatMessagesScreen widget;
  final ChatEntity chat;

  const UserProfileScreen({super.key, required this.widget, required this.chat});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Colors.blue;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. الجزء العلوي مع الصورة وسهم الرجوع
          SliverAppBar(
            title: Text('Profile', style: TextStyle(color: Colors.blue, fontSize: 22),),
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            iconTheme: IconThemeData(color: primaryColor),
            backgroundColor: isDark ? Colors.black : Colors.white,
            actions: [_buildPopupMenu(context, isDark)],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _getFormattedUrl(chat.profilePicture),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey, child: const Icon(Icons.person, size: 100)),
                  ),
                  // تدرج لوني لجعل النص والأيقونات واضحة فوق الصورة
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. قائمة المعلومات بتصميم مودرن
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  // هذا الـ Transform هو سر التداخل الأنيق
                  transform: Matrix4.translationValues(0, -40, 0),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    child: Column(
                      children: [
                        SizedBox(height: 24,),
                        // اسم المستخدم
                        Text(
                          widget.userName,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          chat.userStatus,
                          style: TextStyle(
                            color: chat.userStatus.toLowerCase() == 'online' 
                                ? Colors.green 
                                : Colors.red, 
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // صف الإحصائيات
                        _buildQuickStats(isDark),
                        
                        const SizedBox(height: 35),
                        
                        // عنوان قسم المعلومات
                        _buildSectionHeader(AppLocalizations.of(context)!.about, primaryColor),
                        const SizedBox(height: 15),
                        
                        // كارت المعلومات
                        _buildModernInfoCard(cardColor, isDark, context),
                        
                        const SizedBox(height: 30),
                        
                        // زر إرسال رسالة
                        // _buildActionButton(context, primaryColor),
                        
                        const SizedBox(height: 500), // مساحة للسكرول
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ميثود بناء قائمة الخيارات (Block)
  Widget _buildPopupMenu(BuildContext context, bool isDark) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'block',
          child: ListTile(
            leading: const Icon(Icons.block, color: Colors.red),
            title: Text(AppLocalizations.of(context)!.block, style: const TextStyle(color: Colors.red)),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  // ميثود الإحصائيات (Media, Files, Links)
  Widget _buildQuickStats(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statItem("Media", "128", isDark),
        _verticalDivider(isDark),
        _statItem("Files", "45", isDark),
        _verticalDivider(isDark),
        _statItem("Links", "12", isDark),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // بننظف الرقم من أي مسافات
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', ''),
    );
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // لو فيه مشكلة (زي إن الجهاز مفيش فيه تطبيق اتصال)
      debugPrint('Could not launch $launchUri');
    }
  }

  Widget _statItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _verticalDivider(bool isDark) {
    return Container(height: 30, width: 1, color: isDark ? Colors.white10 : Colors.black12);
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13),
      ),
    );
  }

  // كارت المعلومات الموحد
  Widget _buildModernInfoCard(Color bgColor, bool isDark, BuildContext context) {
    return Column(
      children: [
        // كارت رقم الهاتف
        GestureDetector(
          onTap: () {
            if (chat.phoneNumber.isNotEmpty) {
              _makePhoneCall(chat.phoneNumber);
            }
          },
          child: _buildSingleInfoCard(
            bgColor, 
            Icons.phone_outlined, 
            AppLocalizations.of(context)!.phone,
            chat.phoneNumber
          ),
        ),
        const SizedBox(height: 16), // مسافة بين الكروت
        
        // كارت البريد الإلكتروني
        _buildSingleInfoCard(
          bgColor, 
          Icons.email_outlined, 
          AppLocalizations.of(context)!.email,
          chat.email
        ),
        const SizedBox(height: 16),
        
        // كارت عن المستخدم
        _buildSingleInfoCard(
          bgColor, 
          Icons.info_outline, 
          AppLocalizations.of(context)!.about,
          "Product Designer & Developer"
        ),
      ],
    );
  }

  // 2. دالة بناء الكارت المنفرد (Single Card)
  Widget _buildSingleInfoCard(Color bgColor, IconData icon, String value, String sub) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor, // نفس لون الكارت اللي حددناه (رمادي فاتح أو أسود فاتح)
        borderRadius: BorderRadius.circular(20),
        // إضافة ظل خفيف جداً لزيادة العمق بما أننا فصلناهم
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(icon, color: Colors.blue, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value, 
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)
                ),
                const SizedBox(height: 2),
                Text(
                  sub, 
                  style: const TextStyle(fontSize: 12, color: Colors.grey)
                ),
              ],
            ),
          ),
          // سهم صغير في النهاية يعطي شكل الـ Premium
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // Widget _buildActionButton(BuildContext context, Color color) {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       onPressed: () => Navigator.pop(context),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: color,
  //         foregroundColor: Colors.white,
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  //         elevation: 0,
  //       ),
  //       child: const Text("Send Message", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //     ),
  //   );
  // }
}

String _getFormattedUrl(String? path) {
  if (path == null || path.isEmpty) return 'https://i.pravatar.cc/150';
  if (path.startsWith('http')) return path;
  return "${ApiConstants.baseUrl}/${path.startsWith('/') ? path.substring(1) : path}";
}