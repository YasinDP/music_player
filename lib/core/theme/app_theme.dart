import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_colors.dart';

class AppTheme {
  // Generated via
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF7C5800),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFDEA7),
    onPrimaryContainer: Color(0xFF271900),
    secondary: Color(0xFF6D5C3F),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF7DFBB),
    onSecondaryContainer: Color(0xFF251A04),
    tertiary: Color(0xFF4C6544),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFCEEBC1),
    onTertiaryContainer: Color(0xFF0A2007),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF1E1B16),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF1E1B16),
    surfaceVariant: Color(0xFFEEE1CF),
    onSurfaceVariant: Color(0xFF4E4639),
    outline: Color(0xFF807667),
    onInverseSurface: Color(0xFFF8EFE7),
    inverseSurface: Color(0xFF34302A),
    inversePrimary: Color(0xFFFFBB1C),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF7C5800),
    outlineVariant: Color(0xFFD1C5B4),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFBB1C),
    onPrimary: Color(0xFF412D00),
    primaryContainer: Color(0xFF5E4200),
    onPrimaryContainer: Color(0xFFFFDEA7),
    secondary: Color(0xFFDAC4A0),
    onSecondary: Color(0xFF3C2E15),
    secondaryContainer: Color(0xFF54452A),
    onSecondaryContainer: Color(0xFFF7DFBB),
    tertiary: Color(0xFFB3CEA6),
    onTertiary: Color(0xFF1F361A),
    tertiaryContainer: Color(0xFF354D2E),
    onTertiaryContainer: Color(0xFFCEEBC1),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1E1B16),
    onBackground: Color(0xFFE9E1D9),
    surface: Color(0xFF1E1B16),
    onSurface: Color(0xFFE9E1D9),
    surfaceVariant: Color(0xFF4E4639),
    onSurfaceVariant: Color(0xFFD1C5B4),
    outline: Color(0xFF9A8F80),
    onInverseSurface: Color(0xFF1E1B16),
    inverseSurface: Color(0xFFE9E1D9),
    inversePrimary: Color(0xFF7C5800),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFFFBB1C),
    outlineVariant: Color(0xFF4E4639),
    scrim: Color(0xFF000000),
  );

  // Default Themes
  static ElevatedButtonThemeData? elevatedButtonTheme(context) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                }
                return AppColor.primary;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return Theme.of(context).colorScheme.onSecondary;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ))),
      );
}
