import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/auth/auth_page.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/home/home_page.dart';
import 'package:music_player/music/favorites_page.dart';
import 'package:music_player/music/models.dart';
import 'package:music_player/music/music_player_page.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: HomePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: [
          GoRoute(
            path: MusicPlayerPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return MusicPlayerPage(
                music: state.extra as Music,
              );
            },
          ),
          GoRoute(
            path: FavoritesPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const FavoritesPage();
            },
          ),
        ],
      ),
      GoRoute(
        path: AuthPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthPage();
        },
      ),
    ],
    // errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
    redirect: (context, state) {
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      // final bool loggingIn = state.matchedLocation == AuthPage.routeName;
      if (!loggedIn) return AuthPage.routeName;
      if (loggedIn) {
        if (state.matchedLocation == AuthPage.routeName) {
          return HomePage.routeName;
        }
        if (state.matchedLocation == MusicPlayerPage.routeName.path &&
            (state.extra is! Music)) {
          return HomePage.routeName;
        }
      }
      return null;
    },
  );
}
