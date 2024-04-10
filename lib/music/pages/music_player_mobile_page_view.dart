import 'dart:math';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/music/widgets/animated_favorite_icon.dart';
import 'package:music_player/music/widgets/music_player_mobile_content.dart';
import 'package:music_player/music/widgets/thumbnail_view.dart';

class MusicPlayerMobilePageView extends StatelessWidget {
  const MusicPlayerMobilePageView({
    super.key,
    required this.music,
  });

  final Music music;

  @override
  Widget build(BuildContext context) {
    final double circleAvatarRadius = min(100, context.width * 0.38);
    final double iconSize = min(100, context.width * 0.2);
    return Stack(
      children: [
        Positioned(
          top: context.height * 0.26,
          left: -context.width / 2,
          child: ClipRRect(
            child: CircleAvatar(
              radius: context.width,
              backgroundColor: context.themeData.colorScheme.primaryContainer,
              child: MusicPlayerMobileContent(music: music),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: context.height * 0.12,
          child: NeumorphicButton(
            padding: const EdgeInsets.all(16.0),
            style: const NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.circle(),
              depth: 5,
              intensity: 5,
              color: AppColor.button,
            ),
            child: NeumorphicButton(
              style: const NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.circle(),
                depth: 5,
                intensity: 5,
              ),
              child: CircleAvatar(
                radius: circleAvatarRadius,
                child: Hero(
                  tag: music.id,
                  child: ThumbnailView(
                    imageUrl: music.image,
                    imageBytes: music.imageBytes,
                    isAsset: music.isAsset,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: (context.height * 0.12) +
              (circleAvatarRadius * 2) -
              (iconSize * 0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    color: AppColor.button,
                    size: iconSize + 10,
                  ),
                  AnimatedFavoriteIcon(
                    musicId: music.id,
                    playDuration: 500.ms,
                    iconColor: AppColor.primary,
                    disabledIconColor: AppColor.textFieldColor,
                    size: iconSize,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
