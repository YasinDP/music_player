import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/music/widgets/animated_favorite_icon.dart';
import 'package:music_player/music/widgets/thumbnail_view.dart';

class MusicCard extends StatelessWidget {
  final Music music;
  final Color? iconColor;

  const MusicCard({
    Key? key,
    required this.music,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playDuration = 600.ms;
    return Container(
      // color: context.themeData.colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _AnimatedThumbnail(
            musicId: music.id,
            imageUrl: music.image,
            playDuration: playDuration,
            imageBytes: music.imageBytes,
            isAsset: music.isAsset,
          ),
          SizedBox(width: min(10, context.width * 0.1)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AnimatedTitle(
                  playDuration: playDuration,
                  title: music.title,
                ),
                _AnimatedDescription(
                    playDuration: playDuration, description: music.artist)
              ],
            ),
          ),
          SizedBox(width: min(10, context.width * 0.1)),
          AnimatedFavoriteIcon(
            playDuration: playDuration,
            musicId: music.id,
            iconColor: iconColor,
          )
        ],
      ),
    );
  }
}

class _AnimatedThumbnail extends StatelessWidget {
  final Duration playDuration;
  final String musicId;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final bool isAsset;
  const _AnimatedThumbnail({
    Key? key,
    required this.playDuration,
    required this.musicId,
    required this.imageUrl,
    required this.imageBytes,
    required this.isAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: min(50, context.width * 0.1),
        height: min(50, context.width * 0.1),
        constraints: const BoxConstraints(maxHeight: 100, maxWidth: 100),
        color: context.themeData.colorScheme.background,
        child: Hero(
          tag: musicId,
          child: ThumbnailView(
            imageUrl: imageUrl,
            imageBytes: imageBytes,
            isAsset: isAsset,
          ),
        ),
      ).animate(delay: 400.ms).shimmer(duration: playDuration - 200.ms).flip(),
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  final Duration playDuration;
  final String title;
  const _AnimatedTitle({
    Key? key,
    required this.playDuration,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      softWrap: true,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w500),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: playDuration, curve: Curves.decelerate)
        .slideX(begin: 0.2, end: 0);
  }
}

class _AnimatedDescription extends StatelessWidget {
  final Duration playDuration;
  final String description;
  const _AnimatedDescription({
    Key? key,
    required this.playDuration,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(top: 10, left: 5, bottom: 10),
      constraints: const BoxConstraints(maxWidth: 150),
      child: Text(description,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
              style: Theme.of(context).textTheme.labelLarge)
          .animate()
          .scaleXY(
              begin: 0,
              end: 1,
              delay: 300.ms,
              duration: playDuration - 100.ms,
              curve: Curves.decelerate),
    );
  }
}
