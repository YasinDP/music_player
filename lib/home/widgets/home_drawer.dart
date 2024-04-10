import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/constants/assets.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/music/favorites_page.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    final user = context.watch<AuthProvider>().localUser;
    return Drawer(
      backgroundColor: isDarkMode
          ? context.themeData.colorScheme.background
          : context.themeData.colorScheme.primaryContainer,
      shape: context.isDesktop
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            )
          : null,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? context.themeData.colorScheme.primaryContainer
                  : AppColor.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: min(36, context.width * 0.2),
                  backgroundColor: Colors.blue.shade900,
                  child: Image.asset(Assets.profileImage),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.name ?? "Unknown",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  user?.email ?? "user@musicplayer.com",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            title: const Text('Change Theme'),
            onTap: () => context.read<ThemeProvider>().toggleThemeMode(),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () => context.go(FavoritesPage.routeName.path),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => context.read<AuthProvider>().logoutUser(),
          ),
        ],
      ),
    );
  }
}
