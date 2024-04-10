import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/constants/app_colors.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.audioPlayer,
    required AnimationController animationController,
  }) : _animationController = animationController;

  final AudioPlayer audioPlayer;
  final AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (audioPlayer.processingState == ProcessingState.completed) {
          audioPlayer.play();
        } else if (audioPlayer.playing) {
          audioPlayer.pause();
        } else {
          audioPlayer.play();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppColor.secondaryGradient,
              AppColor.primaryGradient,
            ])),
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
          color: Colors.white,
          size: 54,
        ),
      ),
    );
  }
}
