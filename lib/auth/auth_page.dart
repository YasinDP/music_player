import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/auth/widgets/auth_form.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  static const String routeName = "/auth";
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return Scaffold(
      body: Row(
        children: [
          if (context.largerThanTablet)
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: SizedBox(
                  height: context.height,
                  child: Image.asset(
                    "assets/auth_bg_light.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () =>
                          context.read<ThemeProvider>().toggleThemeMode(),
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        size: min(43, context.width * 0.1),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: AuthForm(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
