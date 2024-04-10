import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/route/app_route.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/core/theme/color_schemes.g.dart';
import 'package:music_player/core/theme/custom_color.g.dart';
import 'package:music_player/providers/auth_provider.dart' as auth;
import 'package:music_player/providers/music_provider.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyDq5iRAqfX9FPzUH9NEtXBP9bdS8W6EOC0",
            // authDomain: "music-player-558d3.firebaseapp.com",
            projectId: "music-player-558d3",
            // storageBucket: "music-player-558d3.appspot.com",
            messagingSenderId: "972955272440",
            appId: "1:972955272440:web:e755ed2cec5732cee5670d",
            // measurementId: "G-ZPTPYGG91Z",
          )
        : const FirebaseOptions(
            apiKey: 'AIzaSyBdkqobM9K8IF3mX3tIC3-7J1Mut8OHNYM',
            appId: '1:972955272440:android:b81c4d830baa1005e5670d',
            messagingSenderId: '972955272440',
            projectId: 'music-player-558d3',
            storageBucket: 'music-player-558d3.appspot.com',
          ),
  );

  // Listen for Auth changes and .refresh the GoRouter [router]
  GoRouter router = AppRoute.router;
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    router.refresh();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => auth.AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Music Player",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        elevatedButtonTheme: AppTheme.elevatedButtonTheme(context),
        extensions: [lightCustomColors],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        elevatedButtonTheme: AppTheme.elevatedButtonTheme(context),
        extensions: [darkCustomColors],
      ),
      themeMode: themeMode,
      routerConfig: AppRoute.router,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child ?? const SizedBox(),
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
