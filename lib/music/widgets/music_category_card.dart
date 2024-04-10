// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/theme/color_schemes.g.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/core/utils/responsive_layout.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/providers/music_provider.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class MusicCategoryCard extends StatelessWidget {
  final MusicCategory category;
  final double? cardHeight;

  const MusicCategoryCard({
    Key? key,
    required this.category,
    this.cardHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = context.watch<MusicProvider>().musicCategory == category;
    final Color textColor = isSelected
        ? context.themeData.primaryColorLight
        : context.themeData.primaryColor;
    final Color borderColor = isSelected
        ? context.themeData.colorScheme.primary
        : darkColorScheme.onBackground;
    final Color bgColor =
        isSelected ? AppColor.primary : darkColorScheme.onBackground;
    Widget desktopView = _MusicCategoryDesktopCard(
      cardHeight: cardHeight,
      category: category,
      bgColor: bgColor,
      borderColor: borderColor,
      textColor: textColor,
    );
    return ResponsiveLayout(
      mobile: _MusicCategoryMobileCard(
        category: category,
        bgColor: bgColor,
        borderColor: borderColor,
        textColor: textColor,
      ),
      tablet: desktopView,
      desktop: desktopView,
    );
  }
}

class _MusicCategoryMobileCard extends StatelessWidget {
  final MusicCategory category;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const _MusicCategoryMobileCard({
    Key? key,
    required this.category,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          context.read<MusicProvider>().updateMusicCategory(category);
        },
        child: Row(
          children: [
            Image.asset(
              category.image,
              width: context.width * 0.05,
              height: context.width * 0.05,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 5),
            Center(
              child: Text(
                category.name.titleCase,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MusicCategoryDesktopCard extends StatelessWidget {
  final MusicCategory category;
  final double? cardHeight;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const _MusicCategoryDesktopCard({
    Key? key,
    required this.category,
    this.cardHeight,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget icon = Image.asset(
      category.image,
      width: min(50, context.width * 0.1),
      height: min(50, context.width * 0.1),
      fit: BoxFit.contain,
    );
    return Container(
      width: cardHeight,
      height: cardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 4),
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          context.read<MusicProvider>().updateMusicCategory(category);
        },
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1,
              child: icon,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.4,
                child: icon,
              ),
            ),
            const SizedBox(width: 5),
            Center(
              child: Text(
                category.name.sentenceCase,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
