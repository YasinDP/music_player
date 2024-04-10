import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/music_player_page.dart';
import 'package:music_player/music/widgets/gradient_scaffold.dart';
import 'package:music_player/music/widgets/music_card.dart';
import 'package:music_player/providers/music_provider.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  static const String routeName = "favorites";
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteMusics = context.read<MusicProvider>().favoriteMusics;

    return GradientScaffold(
      child: favoriteMusics.isEmpty
          ? Center(
              child: SizedBox(
                width: context.width * 0.5,
                child: Text(
                  "You havent added any songs as your favorites",
                  textAlign: TextAlign.center,
                  style: context.themeData.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMusics.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  context.push(
                    MusicPlayerPage.routeName.path,
                    extra: favoriteMusics[index],
                  );
                },
                child: MusicCard(
                  music: favoriteMusics[index],
                  iconColor: context.themeData.colorScheme.secondary,
                ).animate().slideX(
                    duration: 200.ms,
                    delay: 0.ms,
                    begin: 1,
                    end: 0,
                    curve: Curves.easeInOutSine),
              ),
            ),
    );
  }
}
