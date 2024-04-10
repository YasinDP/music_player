import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/music/models.dart';

class MusicProgressBar extends StatefulWidget {
  const MusicProgressBar({
    super.key,
    required this.music,
    required this.audioPlayer,
  });
  final Music music;
  final AudioPlayer audioPlayer;

  @override
  State<MusicProgressBar> createState() => _MusicProgressBarState();
}

class _MusicProgressBarState extends State<MusicProgressBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.audioPlayer.positionStream,
      builder: (context, snapshot) => ProgressBar(
        progress: snapshot.data ?? Duration.zero,
        buffered: widget.audioPlayer.bufferedPosition,
        total: widget.audioPlayer.duration ?? Duration.zero,
        progressBarColor: Colors.red,
        baseBarColor: Colors.white.withOpacity(0.24),
        bufferedBarColor: Colors.white.withOpacity(0.24),
        thumbColor: Colors.white,
        barHeight: 3.0,
        thumbRadius: 5.0,
        onSeek: (duration) {
          widget.audioPlayer.seek(duration);
        },
      ),
    );
  }
}
