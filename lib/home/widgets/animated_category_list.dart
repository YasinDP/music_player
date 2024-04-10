import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/widgets/music_category_card.dart';
import 'package:music_player/music/models.dart';

class AnimatedCategoryList extends StatelessWidget {
  final Duration categoryListPlayDuration;
  final Duration categoryListDelayDuration;
  const AnimatedCategoryList({
    Key? key,
    required this.categoryListPlayDuration,
    required this.categoryListDelayDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardHeight =
        context.isMobile ? 50 : min(150, context.width * 0.3);
    return SizedBox(
      width: context.width,
      height: cardHeight,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 15),
          children: List.generate(
            MusicCategory.values.length,
            (index) => MusicCategoryCard(
              cardHeight: cardHeight,
              category: MusicCategory.values[index],
            ),
          ).animate(interval: 100.ms, delay: categoryListDelayDuration).slideX(
              duration: categoryListPlayDuration,
              begin: 3,
              end: 0,
              curve: Curves.easeInOutSine),
        ),
      ),
    );
  }
}
