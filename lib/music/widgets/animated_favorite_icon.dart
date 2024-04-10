import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/providers/music_provider.dart';
import 'package:provider/provider.dart';

class AnimatedFavoriteIcon extends StatelessWidget {
  final Duration playDuration;
  final String musicId;
  final Color? iconColor;
  final Color? disabledIconColor;
  final double? size;

  const AnimatedFavoriteIcon({
    Key? key,
    required this.playDuration,
    required this.musicId,
    this.iconColor,
    this.disabledIconColor,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFavorite =
        context.watch<MusicProvider>().favoriteMusicIds.contains(musicId);
    Color? color = isFavorite
        ? iconColor ?? AppColor.primary
        : disabledIconColor ?? iconColor ?? AppColor.cardColor;
    return IconButton(
      onPressed: () {
        context.read<MusicProvider>().toggleFavorite(musicId);
      },
      icon: Icon(
        disabledIconColor != null
            ? Icons.favorite_rounded
            : isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
        color: color,
        size: size,
      ),
    ).animate().scaleXY(
        begin: 0,
        end: 1,
        delay: 300.ms,
        duration: playDuration - 100.ms,
        curve: Curves.decelerate);
  }
}
