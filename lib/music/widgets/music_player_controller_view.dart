import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/music/widgets/music_progress_bar.dart';
import 'package:music_player/music/widgets/play_pause_button.dart';
import 'package:music_player/music/widgets/skip_button.dart';

class MusicPlayerControllerView extends StatelessWidget {
  const MusicPlayerControllerView({
    super.key,
    required this.music,
    required this.audioPlayer,
    this.width,
    required AnimationController animationController,
  }) : _animationController = animationController;

  final Music music;
  final AudioPlayer audioPlayer;
  final double? width;
  final AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    final double height = context.height;
    return Column(
      children: [
        SizedBox(
          width: width,
          child: MusicProgressBar(
            music: music,
            audioPlayer: audioPlayer,
          ),
        ),
        SizedBox(height: height * 0.01),
        SizedBox(
          height: 80,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: SkipButton(
                  onTap: () {
                    int timeToSkipInMilliseconds = 10 * 1000;
                    int currentPositionInMilliSeconds =
                        audioPlayer.position.inMilliseconds;
                    if (audioPlayer.position.inMilliseconds >
                        timeToSkipInMilliseconds) {
                      audioPlayer.seek(
                        Duration(
                          milliseconds: currentPositionInMilliSeconds -
                              timeToSkipInMilliseconds,
                        ),
                      );
                    } else {
                      audioPlayer.seek(Duration.zero);
                    }
                  },
                  isForward: false,
                ),
              ),
              PlayPauseButton(
                  audioPlayer: audioPlayer,
                  animationController: _animationController),
              Align(
                alignment: Alignment.bottomRight,
                child: SkipButton(
                  onTap: () {
                    int timeToSkipInMilliseconds = 10 * 1000;
                    int totalDurationInMilliseconds =
                        audioPlayer.duration?.inMilliseconds ?? 0;
                    int currentPositionInMilliSeconds =
                        audioPlayer.position.inMilliseconds;
                    int timeLeftInMilliSeconds = totalDurationInMilliseconds -
                        audioPlayer.position.inMilliseconds;
                    if (timeLeftInMilliSeconds > timeToSkipInMilliseconds) {
                      audioPlayer.seek(
                        Duration(
                          milliseconds: currentPositionInMilliSeconds +
                              timeToSkipInMilliseconds,
                        ),
                      );
                    } else {
                      audioPlayer.seek(
                        Duration(
                          milliseconds: totalDurationInMilliseconds - 1000,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
