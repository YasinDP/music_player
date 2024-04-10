import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/music/widgets/music_player_controller_view.dart';

class MusicPlayerMobileContent extends StatefulWidget {
  const MusicPlayerMobileContent({
    super.key,
    required this.music,
  });
  final Music music;

  @override
  State<MusicPlayerMobileContent> createState() =>
      _MusicPlayerMobileContentState();
}

class _MusicPlayerMobileContentState extends State<MusicPlayerMobileContent>
    with TickerProviderStateMixin {
  final audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  Duration? duration;
  StreamSubscription<PlayerState>? playerStateStream;

  @override
  void initState() {
    initialise();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    super.initState();
  }

  void initialise() async {
    if (widget.music.isAsset) {
      duration = await audioPlayer.setAsset(widget.music.path);
    } else {
      duration = await audioPlayer.setFilePath(widget.music.path);
    }

    playerStateStream = audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _animationController.reset();
        audioPlayer.stop();
        audioPlayer.seek(Duration.zero);
      } else if (event.playing) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    audioPlayer.stop();
    audioPlayer.dispose();
    playerStateStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = context.width;
    final double height = context.height;
    return SizedBox(
      width: width * 0.7,
      child: Column(
        children: [
          SizedBox(height: height * 0.32),
          Text(
            widget.music.title,
            textAlign: TextAlign.center,
            style: context.themeData.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            widget.music.artist,
            textAlign: TextAlign.center,
            style: context.themeData.textTheme.titleMedium,
          ),
          SizedBox(height: height * 0.01),
          MusicPlayerControllerView(
            music: widget.music,
            audioPlayer: audioPlayer,
            animationController: _animationController,
          ),
        ],
      ),
    );
  }
}
