import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/music/widgets/music_player_desktop_content.dart';
import 'package:music_player/music/widgets/thumbnail_view.dart';

class MusicPlayerDesktopPageView extends StatelessWidget {
  const MusicPlayerDesktopPageView({
    super.key,
    required this.music,
  });

  final Music music;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: context.width * 0.2,
          top: -context.height / 2,
          child: ClipRRect(
            child: CircleAvatar(
              radius: context.height,
              backgroundColor: context.themeData.colorScheme.primaryContainer,
              child: MusicPlayerDesktopContent(music: music),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: context.width * 0.08,
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
                radius: context.height * 0.28,
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
      ],
    );
  }
}
