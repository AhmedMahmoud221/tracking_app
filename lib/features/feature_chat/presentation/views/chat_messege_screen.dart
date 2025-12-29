import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/custom_audio_bubble.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/custom_header_chat_screen.dart';

class ChatMessagesScreen extends StatefulWidget {
  final String userName;
  const ChatMessagesScreen({super.key, required this.userName});

  @override
  State<ChatMessagesScreen> createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isRecording = false;
  double _swipePosition = 0.0;
  int _recordDuration = 0; // بالثواني
  Timer? _timer;

  // fake messages data
  final List<Map<String, dynamic>> messages = [
    {"text": "هلا، كيف حالك؟", "isMe": false, "time": "10:00 AM"},
    {"text": "الحمدلله بخير، أنت كيفك؟", "isMe": true, "time": "10:01 AM"},
    {"text": "شغال على المشروع الجديد؟", "isMe": false, "time": "10:02 AM"},
    {"text": "أيوه، وقربت أخلصه إن شاء الله 🚀", "isMe": true, "time": "10:05 AM"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5), // خلفية الشات
      appBar: AppBar(
        titleSpacing: 0,
        title: CustomHeaderChatScreen(widget: widget),
      ),
      body: Column(
        children: [
          // show messages & audio bubbles
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                if (msg['type'] == 'voice') {
                  return AudioBubble(
                    isMe: msg['isMe'],
                    time: msg['time'],
                    audioUrl: msg['audioUrl'],
                  );
                } else {
                  return _buildChatBubble(msg['text'], msg['isMe'], msg['time'], isDark);
                }
              },
            ),
          ),

          // message input
          _buildMessageInput(isDark),
        ],
      ),
    );
  }

  // messege bubble widget
  Widget _buildChatBubble(String text, bool isMe, String time, bool isDark) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe 
              ? Colors.blue 
              : (isDark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isMe ? 15 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // message input widget
  // 1. دالة لبدء العداد
  void _startTimer() {
    _recordDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  // 2. دالة لإيقاف العداد
  void _stopTimer() {
    _timer?.cancel();
    setState(() => _recordDuration = 0);
  }

  // 3. تحويل الثواني لصيغة 00:00
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget _buildMessageInput(bool isDark) {
    bool isTextEmpty = _messageController.text.trim().isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          // زر الإضافة يختفي أثناء التسجيل لتوفير مساحة
          if (!_isRecording)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.blue),
              onPressed: () {
                /* كود الـ BottomSheet الخاص بك */
              },
            ),

          Expanded(
            child: _isRecording
                ? _buildRecordingWave(isDark) // واجهة التسجيل
                : _buildTextField(isDark),   // واجهة الكتابة العادية
          ),

          const SizedBox(width: 5),

          // زر المايك مع الـ Gestures
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (_isRecording) {
                setState(() {
                  _swipePosition += details.delta.dx;
                  // إذا سحب المستخدم لليسار بمقدار معين نلغي التسجيل
                  if (_swipePosition < -120) {
                    _isRecording = false;
                    _stopTimer();
                    print("Recording Cancelled");
                  }
                });
              }
            },
            onLongPress: () {
              if (isTextEmpty) {
                setState(() {
                  _isRecording = true;
                  _swipePosition = 0;
                });
                _startTimer();
                print("بدأ التسجيل برمجياً هنا...");
              }
            },
            onLongPressEnd: (details) async{
              if (_isRecording) {
                setState(() => _isRecording = false);
                _stopTimer();
                if (_swipePosition > -120) {
                  print("تم الإرسال بنجاح");
                }
              }
            },
            child: CircleAvatar(
              backgroundColor: _isRecording ? Colors.red : Colors.blue,
              radius: _isRecording ? 28 : 25, // تكبير الزر أثناء التسجيل
              child: Icon(
                isTextEmpty ? (_isRecording ? Icons.mic : Icons.mic_none) : Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ودجت الـ TextField العادي
  Widget _buildTextField(bool isDark) {
    return TextField(
      controller: _messageController,
      onChanged: (val) => setState(() {}),
      decoration: InputDecoration(
        hintText: "Type a message...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDark ? Colors.black : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  // ودجت حالة التسجيل (Animation & Slide to cancel)
  Widget _buildRecordingWave(bool isDark) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // أيقونة حمراء تنبض
          const Icon(Icons.circle, color: Colors.green, size: 12),
          const SizedBox(width: 8),
          Text(_formatDuration(_recordDuration), style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          // نص السحب للإلغاء مع أنيميشن بسيط
          Opacity(
            opacity: (1.0 + (_swipePosition / 120)).clamp(0.0, 1.0),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_ios, size: 12, color: Colors.grey),
                Text(" Slide to cancel", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}