import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/core/constants/assets.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/home/widgets/animated_name_widget.dart';
import 'package:music_player/home/widgets/music_search_bar.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:music_player/home/home_page.dart';

class AnimatedAppBarWidget extends StatelessWidget {
  final Duration avatarWaitingDuration;
  final Duration avatarPlayDuration;
  final Duration nameDelayDuration;
  final Duration namePlayDuration;

  const AnimatedAppBarWidget({
    Key? key,
    required this.avatarWaitingDuration,
    required this.avatarPlayDuration,
    required this.nameDelayDuration,
    required this.namePlayDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedTextLogo(
              namePlayDuration: namePlayDuration,
              nameDelayDuration: nameDelayDuration,
            ),
            const Spacer(),
            if (!context.isMobile) const MusicSearchBar(),
            if (!context.isDesktop)
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        context.read<ThemeProvider>().toggleThemeMode(),
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      size: min(42, context.width * 0.1),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      if (scaffoldKey.currentState?.isDrawerOpen != true) {
                        scaffoldKey.currentState?.openDrawer();
                        return;
                      }
                      scaffoldKey.currentState?.closeDrawer();
                    },
                    child: CircleAvatar(
                      radius: min(10, context.width * 0.1),
                      backgroundColor: Colors.blue.shade900,
                      child: Image.asset(Assets.profileImage),
                    )
                        .animate()
                        .scaleXY(
                            begin: 0,
                            end: 2,
                            duration: avatarPlayDuration,
                            curve: Curves.easeInOutSine)
                        .then(delay: avatarWaitingDuration)
                        .scaleXY(begin: 3, end: 1)
                        .slide(begin: const Offset(-4, 6), end: Offset.zero),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
