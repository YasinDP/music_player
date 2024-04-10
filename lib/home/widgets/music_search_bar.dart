import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/providers/music_provider.dart';
import 'package:provider/provider.dart';

class MusicSearchBar extends StatefulWidget {
  const MusicSearchBar({
    super.key,
  });

  @override
  State<MusicSearchBar> createState() => _MusicSearchBarState();
}

class _MusicSearchBarState extends State<MusicSearchBar> {
  TextEditingController controller = TextEditingController();

  bool showCancelButton = false;

  @override
  void initState() {
    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        showCancelButton = true;
      } else {
        showCancelButton = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.4,
      constraints: const BoxConstraints(maxWidth: 500),
      child: TextField(
        onChanged: (value) =>
            context.read<MusicProvider>().updateSearchQuery(value),
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.textFieldColor,
          prefixIcon: Icon(
            Icons.search,
            color: context.themeData.colorScheme.primary,
          ),
          suffixIcon: showCancelButton
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    context.read<MusicProvider>().updateSearchQuery("");
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: context.themeData.colorScheme.error,
                  ),
                )
              : null,
          hintText: context.isTablet
              ? "Search songs.."
              : "Search songs by title or author..",
          hintStyle: TextStyle(color: context.themeData.colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: context.themeData.primaryColor,
              width: 1.5,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
