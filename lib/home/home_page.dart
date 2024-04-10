import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/home/widgets/animated_appbar_widget.dart';
import 'package:music_player/home/widgets/animated_category_list.dart';
import 'package:music_player/home/widgets/animates_musics_list_view.dart';
import 'package:music_player/home/widgets/home_drawer.dart';
import 'package:music_player/home/widgets/music_search_bar.dart';
import 'package:music_player/providers/music_provider.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:provider/provider.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatelessWidget {
  static const String routeName = "/";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeContent();
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    context.read<MusicProvider>().syncFavoritesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final avatarPlayDuration = 500.ms;
    final avatarWaitingDuration = 400.ms;
    final nameDelayDuration =
        avatarWaitingDuration + avatarWaitingDuration + 200.ms;
    final namePlayDuration = 800.ms;
    final categoryListPlayDuration = 750.ms;
    final categoryListDelayDuration =
        nameDelayDuration + namePlayDuration - 400.ms;
    // Create musicListKey to refresh the AnimatedMusicsListView widget
    // whenever searchQuery or Category selection is updated
    final String musicsListKey = context.select<MusicProvider, String>(
      (value) => value.searchQuery + value.musicCategory.name,
    );
    return Scaffold(
      key: scaffoldKey,
      drawer: const HomeDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: context.watch<ThemeProvider>().themeMode == ThemeMode.light
              ? const LinearGradient(
                  colors: [
                    AppColor.primaryGradient,
                    AppColor.secondaryGradient,
                  ], // Define your gradient colors
                  begin: Alignment.topCenter, // Alignment of the gradient start
                  end: Alignment.center, // Alignment of the gradient end
                )
              : null,
        ),
        child: Row(
          children: [
            if (context.isDesktop)
              SizedBox(
                width: context.width * 0.25,
                child: const HomeDrawer(),
              ),
            Expanded(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15),
                      AnimatedAppBarWidget(
                        avatarWaitingDuration: avatarWaitingDuration,
                        avatarPlayDuration: avatarPlayDuration,
                        nameDelayDuration: nameDelayDuration,
                        namePlayDuration: namePlayDuration,
                      ),
                      if (context.isMobile)
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: MusicSearchBar(),
                        ),
                      const SizedBox(height: 15),
                      AnimatedCategoryList(
                        categoryListPlayDuration: categoryListPlayDuration,
                        categoryListDelayDuration: categoryListDelayDuration,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      child: Container(
                        color: context.themeData.colorScheme.primaryContainer,
                        child: AnimatedMusicsListView(
                          key: ValueKey(musicsListKey),
                        ),
                      ),
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
}
