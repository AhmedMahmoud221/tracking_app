import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioBubble extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final String time;

  const AudioBubble({
    super.key,
    required this.audioUrl,
    required this.isMe,
    required this.time,
  });

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isDragging = false; // عشان السلايدر ميتنططش وأنت بتسحب

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // إعدادات المصدر والحالات
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) setState(() => _duration = newDuration);
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      // بنحدث الـ position فقط لو المستخدم مش بيسحب السلايدر حالياً
      if (mounted && !_isDragging) {
        setState(() => _position = newPosition);
      }
    });

    // لما الريكورد يخلص يرجع للبداية
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // ملحوظة: UrlSource بتشتغل مع الروابط اللي بتبدأ بـ http
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
        decoration: BoxDecoration(
          color: widget.isMe 
              ? Colors.blue 
              : (isDark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(widget.isMe ? 15 : 0),
            bottomRight: Radius.circular(widget.isMe ? 0 : 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // زرار التشغيل
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 35,
                  ),
                  onPressed: _playPause,
                  color: widget.isMe ? Colors.white : Colors.blue,
                ),
                // السلايدر
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      activeColor: widget.isMe ? Colors.white : Colors.blue,
                      inactiveColor: widget.isMe ? Colors.white30 : Colors.grey[300],
                      min: 0,
                      max: _duration.inSeconds.toDouble() > 0 
                          ? _duration.inSeconds.toDouble() 
                          : 1.0,
                      value: _position.inSeconds.toDouble(),
                      onChangeStart: (val) => _isDragging = true,
                      onChanged: (value) {
                        setState(() {
                          _position = Duration(seconds: value.toInt());
                        });
                      },
                      onChangeEnd: (value) async {
                        _isDragging = false;
                        await _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 5, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: TextStyle(
                      fontSize: 10, 
                      color: widget.isMe ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(
                      fontSize: 10, 
                      color: widget.isMe ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}