import 'package:music_player/core/utils/responsive_layout.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/music/pages/music_player_desktop_page_view.dart';
import 'package:music_player/music/pages/music_player_mobile_page_view.dart';
import 'package:music_player/music/widgets/gradient_scaffold.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MusicPlayerPage extends StatelessWidget {
  static const String routeName = "music";

  const MusicPlayerPage({
    super.key,
    required this.music,
  });

  final Music music;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: ResponsiveLayout(
        mobile: MusicPlayerMobilePageView(music: music),
        desktop: MusicPlayerDesktopPageView(music: music),
      ),
    );
  }
}
