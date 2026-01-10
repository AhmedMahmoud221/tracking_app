import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/message_entity.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_message/chat_message_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_message/chat_message_state.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_socket/chat_socket_cubit.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_socket/chat_socket_state.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/audio_bubble.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/custom_header_chat_screen.dart';
import 'package:live_tracking/features/feature_chat/presentation/views/video_player_screen.dart';
import 'package:live_tracking/l10n/app_localizations.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessagesScreen extends StatefulWidget {
  final String userName;
  final String chatId;
  final String? profilePicture;
  final String email;
  final String phoneNumber;
  final String userStatus;

  const ChatMessagesScreen({
    super.key,
    required this.userName,
    required this.chatId,
    required this.email,
    this.profilePicture,
    required this.phoneNumber,
    required this.userStatus,
  });

  @override
  State<ChatMessagesScreen> createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  late TextEditingController _messageController;
  late AudioRecorder audioRecorder;
  late ChatMessagesCubit _cubit;
  late ChatSocketCubit _socketCubit;

  bool _isRecording = false;
  double _swipePosition = 0.0;
  int _recordDuration = 0;
  Timer? _timer;
  String? myId;

  @override
  void initState() {
    super.initState();
    audioRecorder = AudioRecorder();
    _messageController = context.read<ChatMessagesCubit>().messageController;

    // context.read<ChatListCubit>().markChatAsRead(widget.chatId);

    // نداء ميثود واحدة منظمة
    _startChatFlow();
  }

  Future<void> _startChatFlow() async {
    final id = "6935eccd50c25daeb0dea0b5"; // الـ ID بتاعك

    if (mounted) {
      setState(() {
        myId = id;
      });

      if (myId != null && myId!.isNotEmpty) {
        // مرر الـ id هنا كباراميتر تاني
        context.read<ChatMessagesCubit>().fetchMessages(widget.chatId, myId!);
        context.read<ChatSocketCubit>().connectToChat(widget.chatId);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // نخزن المرجع هنا بأمان
    _cubit = context.read<ChatMessagesCubit>();
    _socketCubit = context.read<ChatSocketCubit>();
  }

  @override
  void dispose() {
    _socketCubit.disconnectFromChat(widget.chatId);

    audioRecorder.dispose();
    _timer?.cancel();

    _cubit.close();
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

  // pickImage method
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      context.read<ChatMessagesCubit>().sendImage(widget.chatId, image.path);
    }
  }

  // pckVideo method
  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      context.read<ChatMessagesCubit>().sendVideo(widget.chatId, video.path);
    }
  }

  // pickDocment method
  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      context.read<ChatMessagesCubit>().sendFile(
        widget.chatId,
        result.files.single.path!,
      );
    }
  }

  //=================================================logic
  // show message images
  Widget _buildImageBubble(MessageEntity msg, bool isDark) {
    final String imageUrl = _getFormattedUrl(msg.mediaUrl);
    bool isMe = msg.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // هنا بنفتح الصورة في Full Screen
              if (imageUrl.isNotEmpty) {
                _showFullImage(imageUrl);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.blue
                    : (isDark ? Colors.grey[800] : Colors.white),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      isDark ? 0.3 : 0.08,
                    ), // الظل أخف في اللايت مود
                    blurRadius: 8,
                    offset: const Offset(0, 2), // إزاحة الظل للأسفل قليلاً
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                imageUrl,
                width: 250,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    width: 250,
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // ميثود سريعة لعرض الصورة كاملة
  void _showFullImage(String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(child: Image.network(url)),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith('http')) return path;

    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final base = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl.substring(0, ApiConstants.baseUrl.length - 1)
        : ApiConstants.baseUrl;

    return "$base/$cleanPath";
  }

  //=================================================logic2
  // show message files
  Widget _buildFileBubble(MessageEntity msg, bool isDark) {
    print("DEBUG: mediaUrl = ${msg.mediaUrl}");
    print("DEBUG: msg.text = ${msg.text}");
    print("DEBUG: msg.fileName = ${msg.fileName}");
    final String formattedFileUrl = _getFormattedUrl(msg.mediaUrl);

    String displayFileName = "Document File";

    if (msg.fileName != null && msg.fileName!.isNotEmpty) {
      displayFileName = msg.fileName!;
    }

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: msg.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              final String rawUrl = formattedFileUrl.trim();
              final Uri url = Uri.parse(rawUrl);

              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("لا يوجد تطبيق لفتح هذا الملف")),
                );
              }
            },
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                // --- التعديل هنا ---
                color: msg.isMe
                    ? (isDark
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.1))
                    : (isDark
                          ? Colors.grey[800]
                          : Colors
                                .white), // خلفية بيضاء في اللايت، ورمادي في الدارك
                // ------------------
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                ),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file,
                    color: Colors.blue,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      displayFileName,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  //=================================================logic3
  // show message videos
  Widget _buildVideoBubble(MessageEntity msg, bool isDark) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: msg.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              String finalUrl = msg.mediaUrl ?? "";
              if (!finalUrl.startsWith('http') && !finalUrl.startsWith('/')) {
                finalUrl = "${ApiConstants.baseUrl}$finalUrl";
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerScreen(url: finalUrl),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: 250,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      isDark ? 0.3 : 0.08,
                    ), // الظل أخف في اللايت مود
                    blurRadius: 8,
                    offset: const Offset(0, 2), // إزاحة الظل للأسفل قليلاً
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50,
                  ),
                  if (msg.mediaUrl != null && msg.mediaUrl!.startsWith('/'))
                    const Positioned(
                      bottom: 5,
                      right: 5,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                    ),
                ],
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

    return BlocListener<ChatSocketCubit, ChatSocketState>(
      listener: (context, state) {
        final chatCubit = context.read<ChatMessagesCubit>();
        if (state is ChatSocketMessageReceived) {
          chatCubit.addIncomingMessageFromSocket(state.message);
        } else if (state is ChatSocketMessageDeleted) {
          chatCubit.removeMessageLocally(state.messageId);
        } else if (state is ChatSocketMessageEdited) {
          chatCubit.updateMessageLocally(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
        appBar: AppBar(
          titleSpacing: 0,
          title: CustomHeaderChatScreen(widget: widget),
          surfaceTintColor:
              Colors.transparent, // يمنع تداخل الألوان عند السكرول
          scrolledUnderElevation: 0,
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
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
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No messages yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Say Hello to start the conversation! 👋",
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final messageKey = ValueKey(msg.id);
                        final time =
                            "${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}";

                        final String msgType = msg.messageType
                            .toString()
                            .toLowerCase();

                        // تجهيز مسار الميديا (لو موجود)
                        String mediaPath = msg.mediaUrl ?? "";
                        if (mediaPath.isNotEmpty &&
                            !mediaPath.startsWith('http') &&
                            !mediaPath.startsWith('/')) {
                          mediaPath = "${ApiConstants.baseUrl}$mediaPath";
                        }

                        // 1. حالة الصوت
                        if (msgType == 'voice' || msgType == 'audio') {
                          return AudioBubble(
                            key: messageKey,
                            isMe: msg.isMe,
                            time: time,
                            audioUrl: mediaPath,
                          );
                        }
                        // 2. حالة الصورة
                        else if (msgType == 'image') {
                          return Container(
                            key: messageKey,
                            child: _buildImageBubble(msg, isDark),
                          );
                        }
                        // 3. حالة الفيديو (جديد)
                        else if (msgType == 'video') {
                          return Container(
                            key: messageKey,
                            child: _buildVideoBubble(msg, isDark),
                          );
                        }
                        // 4. حالة الملفات/المستندات (جديد)
                        else if (msgType == 'file' ||
                            msgType == 'document' ||
                            msgType.contains('application')) {
                          return Container(
                            key: messageKey,
                            child: _buildFileBubble(msg, isDark),
                          );
                        }
                        // 5. الحالة الافتراضية (نص)
                        else {
                          return Container(
                            key: messageKey, // <--- أضفنا الـ Key هنا
                            child: GestureDetector(
                              onLongPress: () => _showOptionsBottomSheet(msg),
                              child: _buildChatBubble(msg, isDark),
                            ),
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
      ),
    );
  }

  //=================================================logic3
  // show Message Bubble
  Widget _buildChatBubble(MessageEntity msg, bool isDark) {
    final bool isMe = msg.isMe;
    final String time = DateFormat('hh:mm a').format(msg.createdAt);

    String displayText = msg.text;
    if (displayText.isEmpty && msg.messageType != 'text') {
      displayText = "وصلك ملف [${msg.messageType}]";
    }

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
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg.isDeleted ? "هذه الرسالة محذوفة" : msg.text,
              style: TextStyle(
                color: msg.isDeleted
                    ? Colors.grey
                    : (isMe || isDark ? Colors.white : Colors.black87),
                fontStyle: msg.isDeleted ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            if (msg.isEdited && !msg.isDeleted)
              const Text(
                "معدلة",
                style: TextStyle(fontSize: 8, color: Colors.grey),
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
              onPressed: () {
                // إظهار قائمة خيارات
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[700],
                            ),
                            title: Text(AppLocalizations.of(context)!.camera),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(
                                ImageSource.camera,
                              ); // نختار من الكاميرا
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.photo_library,
                              color: Colors.grey[700],
                            ),
                            title: Text(AppLocalizations.of(context)!.gallery),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(
                                ImageSource.gallery,
                              ); // نختار من المعرض
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.videocam,
                              color: Colors.grey[700],
                            ),
                            title: Text(AppLocalizations.of(context)!.vedio),
                            onTap: () {
                              Navigator.pop(context);
                              _pickVideo(); // ميثود اختيار الفيديو
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.insert_drive_file,
                              color: Colors.grey[700],
                            ),
                            title: Text(AppLocalizations.of(context)!.document),
                            onTap: () {
                              Navigator.pop(context);
                              _pickDocument(); // ميثود اختيار الملفات
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
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
                    audioRecorder.stop();
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
      maxLines: 5,
      minLines: 1,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.typemessage,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDark ? Colors.black : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 12, color: Colors.grey),
                Text(
                  AppLocalizations.of(context)!.slidetocancel,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(MessageEntity msg) {
    final editController = TextEditingController(text: msg.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تعديل الرسالة"),
        content: TextField(controller: editController, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              _cubit.editMessage(msg.id, msg.text);
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(MessageEntity msg) {
    // المنطق: لا يمكن حذف أو تعديل إلا رسائلي أنا
    if (!msg.isMe) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            if (msg.messageType == 'text') // التعديل للنصوص فقط
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("تعديل الرسالة"),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(msg);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("حذف للجميع"),
              onTap: () {
                Navigator.pop(context);
                _cubit.deleteMessage(msg.id); // نداء الـ Cubit
              },
            ),
          ],
        ),
      ),
    );
  }
}
