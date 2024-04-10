import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
            context.themeData.colorScheme.primaryContainer.withOpacity(0.2),
          )),
          icon: const Icon(
            Icons.keyboard_backspace_sharp,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeProvider>().toggleThemeMode(),
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: context.watch<ThemeProvider>().themeMode == ThemeMode.light
              ? const LinearGradient(
                  colors: [
                    AppColor.primaryGradient,
                    AppColor.secondaryGradient,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}
