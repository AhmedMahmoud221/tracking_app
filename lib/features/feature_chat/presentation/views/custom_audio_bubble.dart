import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioBubble extends StatefulWidget {
  final bool isMe;
  final String time;
  final String? audioUrl; // مسار الملف الصوتي

  const AudioBubble({
    super.key,
    required this.isMe,
    required this.time,
    this.audioUrl,
  });

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // الاستماع لتغيرات المدة والموقع
    _audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => _position = p));
    _audioPlayer.onPlayerComplete.listen((_) => setState(() => _isPlaying = false));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorText = widget.isMe ? Colors.white : (isDark ? Colors.white : Colors.black);

    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.fromLTRB(10, 10, 15, 8),
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: widget.isMe ? Colors.blue : (isDark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(widget.isMe ? 15 : 0),
            bottomRight: Radius.circular(widget.isMe ? 0 : 15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                // زر التشغيل
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: widget.isMe ? Colors.white : Colors.blue,
                    size: 35,
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioPlayer.pause();
                    } else {
                      // هنا تضع مسار الملف الفعلي
                      // await _audioPlayer.play(DeviceFileSource(widget.audioUrl!));
                    }
                    setState(() => _isPlaying = !_isPlaying);
                  },
                ),
                // شريط التقدم (Slider)
                Expanded(
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                    activeColor: widget.isMe ? Colors.white : Colors.blue,
                    inactiveColor: widget.isMe ? Colors.white30 : Colors.grey[300],
                    onChanged: (value) async {
                      await _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Text(
                  _formatDuration(_duration - _position),
                  style: TextStyle(color: colorText, fontSize: 12),
                ),
              ],
            ),
            Text(
              widget.time,
              style: TextStyle(color: widget.isMe ? Colors.white70 : Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}