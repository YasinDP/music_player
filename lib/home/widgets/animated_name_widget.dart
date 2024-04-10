import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/core/constants/assets.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AnimatedTextLogo extends StatelessWidget {
  final Duration namePlayDuration;
  final Duration nameDelayDuration;
  const AnimatedTextLogo({
    super.key,
    required this.namePlayDuration,
    required this.nameDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return Image.asset(
      isDarkMode ? Assets.textLogo : Assets.textLogoLight,
      width: min(150, context.width * 0.3),
      fit: BoxFit.fitWidth,
    )
        .animate()
        .slideX(
            begin: 0.2,
            end: 0,
            duration: namePlayDuration,
            delay: nameDelayDuration,
            curve: Curves.fastOutSlowIn)
        .fadeIn();
  }
}
