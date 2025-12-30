import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_message/chat_message_cubit_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_message/chat_message_cubit_state.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/audio_bubble.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/custom_header_chat_screen.dart';
import 'package:record/record.dart';

class ChatMessagesScreen extends StatefulWidget {
  final String userName;
  final String chatId;

  const ChatMessagesScreen({
    super.key,
    required this.userName,
    required this.chatId,
  });

  @override
  State<ChatMessagesScreen> createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  late TextEditingController _messageController;
  late AudioRecorder audioRecorder;

  bool _isRecording = false;
  double _swipePosition = 0.0;
  int _recordDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    audioRecorder = AudioRecorder();
    _messageController = context.read<ChatMessagesCubit>().messageController;
    context.read<ChatMessagesCubit>().fetchMessages(widget.chatId);
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = Directory.systemTemp;
        final path =
            '${directory.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await audioRecorder.start(const RecordConfig(), path: path);

        setState(() {
          _isRecording = true;
          _recordDuration = 0;
        });
        _startTimer();
      }
    } catch (e) {
      print("Error starting record: $e");
    }
  }

  // show image method
  Widget _buildImageBubble(MessageEntity msg, bool isDark) {
    final String path = msg.mediaUrl ?? "";

    bool isLocal =
        !path.startsWith('http') &&
        (path.startsWith('/') || path.contains('com.example'));

    String finalUrl = path;
    if (!isLocal && path.isNotEmpty && !path.startsWith('http')) {
      finalUrl = "${ApiConstants.baseUrl}$path";
    }

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: msg.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: msg.isMe
                  ? Colors.blue
                  : (isDark ? Colors.grey[800] : Colors.white),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isLocal
                  ? Image.file(
                      File(path), // عرض من الموبايل فوراً
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    )
                  : Image.network(
                      finalUrl, // عرض من السيرفر
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
            ),
          ),
          Text(
            "${msg.createdAt.hour}:${msg.createdAt.minute}",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        titleSpacing: 0,
        title: CustomHeaderChatScreen(widget: widget),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
              builder: (context, state) {
                if (state is ChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatMessagesSuccess) {
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return const Center(child: Text("Say Hello! 👋"));
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final time =
                          "${msg.createdAt.hour}:${msg.createdAt.minute}";

                      final String msgType = msg.messageType
                          .toString()
                          .toLowerCase();

                      String audioPath = msg.mediaUrl ?? "";
                      if (audioPath.isNotEmpty) {
                        if (!audioPath.startsWith('http') &&
                            !audioPath.startsWith('/')) {
                          audioPath = "${ApiConstants.baseUrl}$audioPath";
                        }
                      }

                      if (msgType == 'voice' || msgType == 'audio') {
                        return AudioBubble(
                          isMe: msg.isMe,
                          time: time,
                          audioUrl: audioPath,
                        );
                      } else if (msgType == 'image') {
                        return _buildImageBubble(msg, isDark);
                      } else if (msgType == 'text' || msg.text.isNotEmpty) {
                        return _buildChatBubble(
                          msg.text,
                          msg.isMe,
                          time,
                          isDark,
                        );
                      } else {
                        return _buildChatBubble(
                          "نوع غير مدعوم: [$msgType]",
                          msg.isMe,
                          time,
                          isDark,
                        );
                      }
                    },
                  );
                } else if (state is ChatMessagesError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(child: Text("ابدأ المحادثة الآن"));
              },
            ),
          ),
          _buildMessageInput(isDark),
        ],
      ),
    );
  }

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
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe || isDark ? Colors.white : Colors.black87,
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

  Widget _buildMessageInput(bool isDark) {
    bool isTextEmpty = _messageController.text.trim().isEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          if (!_isRecording)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.blue),
              onPressed: () async {
                // 1. إنشاء نسخة من الـ Picker
                final ImagePicker picker = ImagePicker();

                // 2. اختيار الصورة من المعرض (Gallery)
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                // 3. لو المستخدم اختار صورة فعلاً (مش عمل Cancel)
                if (image != null) {
                  if (context.mounted) {
                    // 4. نبعت المسار للـ Cubit
                    context.read<ChatMessagesCubit>().sendImage(
                      widget.chatId,
                      image.path,
                    );
                  }
                }
              },
            ),
          Expanded(
            child: _isRecording
                ? _buildRecordingWave(isDark)
                : _buildTextField(isDark),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (_isRecording) {
                setState(() {
                  _swipePosition += details.delta.dx;
                  if (_swipePosition < -120) {
                    _isRecording = false;
                    _stopTimer();
                    audioRecorder.stop(); // إيقاف التسجيل عند السحب للحذف
                  }
                });
              }
            },
            onLongPress: () {
              if (isTextEmpty) _startRecording();
            },
            onLongPressEnd: (details) async {
              if (_isRecording) {
                final path = await audioRecorder.stop();
                _stopTimer();
                setState(() => _isRecording = false);
                if (path != null && _swipePosition > -120) {
                  context.read<ChatMessagesCubit>().sendVoice(
                    widget.chatId,
                    path,
                  );
                }
              }
              setState(() => _swipePosition = 0.0);
            },
            onTap: () {
              if (_messageController.text.trim().isNotEmpty) {
                context.read<ChatMessagesCubit>().sendMessage(widget.chatId);
                // مش محتاج تعمل setState هنا لأن الـ BlocBuilder هيحس بالتغيير فوراً
              }
            },
            child: CircleAvatar(
              backgroundColor: _isRecording ? Colors.red : Colors.blue,
              radius: _isRecording ? 28 : 25,
              child: Icon(
                isTextEmpty
                    ? (_isRecording ? Icons.mic : Icons.mic_none)
                    : Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      ),
    );
  }

  void _startTimer() {
    _recordDuration = 0;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => setState(() => _recordDuration++),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _recordDuration = 0);
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

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
          const Icon(Icons.circle, color: Colors.green, size: 12),
          const SizedBox(width: 8),
          Text(
            _formatDuration(_recordDuration),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Opacity(
            opacity: (1.0 + (_swipePosition / 120)).clamp(0.0, 1.0),
            child: const Row(
              children: [
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
