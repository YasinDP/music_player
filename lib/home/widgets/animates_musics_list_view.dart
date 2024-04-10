import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/music_player_page.dart';
import 'package:music_player/music/widgets/music_card.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/providers/music_provider.dart';
import 'package:provider/provider.dart';

class AnimatedMusicsListView extends StatefulWidget {
  const AnimatedMusicsListView({
    super.key,
  });

  @override
  State<AnimatedMusicsListView> createState() => _AnimatedMusicsListViewState();
}

class _AnimatedMusicsListViewState extends State<AnimatedMusicsListView> {
  final ScrollController scrollController = ScrollController();
  List<Music> musics = [];
  late bool _loading;
  late bool _allLoaded;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _allLoaded = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMusics();
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          !_allLoaded) {
        loadMusics();
      }
    });
  }

  void loadMusics() async {
    var newMusics = await context.read<MusicProvider>().fetchMusics(
          offset: musics.length,
          length: 10,
        );
    _loading = false;
    if (newMusics.length < 10) {
      _allLoaded = true;
    }
    musics.addAll(newMusics);
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (musics.isEmpty) {
      return const Center(
        child: Text(
          "Musics are not available based on applied filters. Try changing the filter params.",
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.separated(
      itemCount: _allLoaded ? musics.length : musics.length + 1,
      controller: scrollController,
      padding: const EdgeInsets.all(10),
      itemBuilder: (BuildContext context, int index) {
        if (index < musics.length) {
          return GestureDetector(
            onTap: () {
              context.go(
                MusicPlayerPage.routeName.path,
                extra: musics[index],
              );
            },
            child: MusicCard(music: musics[index]).animate().slideX(
                duration: 200.ms,
                delay: 0.ms,
                begin: 1,
                end: 0,
                curve: Curves.easeInOutSine),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: 60,
          height: 60,
          color: context.themeData.colorScheme.primaryContainer,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 6,
              color: AppColor.primary,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Divider(),
      ),
    );
  }
}
