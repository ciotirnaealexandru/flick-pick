import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme _appColors = ColorScheme.dark(
  primary: const Color.fromARGB(255, 28, 37, 51),
  onPrimary: const Color.fromARGB(255, 178, 166, 255),
  surface: const Color.fromARGB(255, 5, 12, 28),
  onSurface: const Color.fromARGB(255, 178, 166, 255),
  error: const Color.fromARGB(255, 195, 45, 55),

  /* used for checking theme color
  primary: const Color.fromRGBO(12, 77, 47, 1),
  onPrimary: const Color.fromARGB(255, 41, 11, 238),
  surface: const Color.fromARGB(255, 26, 53, 5),
  onSurface: const Color.fromARGB(255, 41, 11, 238),
  error: const Color.fromARGB(255, 195, 45, 55),
  */
);

class AppFonts {
  static String get primary => GoogleFonts.rubik().fontFamily!;
}

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,

  // Use the color scheme
  colorScheme: _appColors,

  // Make the scaffold background match the scheme's surface
  scaffoldBackgroundColor: _appColors.surface,

  // Optional: keep primaryColor for backwards compatibility
  primaryColor: _appColors.primary,

  // Text styles
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: _appColors.onPrimary,
      fontFamily: AppFonts.primary,
    ),
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
      fontFamily: AppFonts.primary,
    ),
    titleMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
      fontFamily: AppFonts.primary,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
      fontFamily: AppFonts.primary,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: _appColors.onPrimary,
      fontFamily: AppFonts.primary,
    ),
    bodySmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
      fontFamily: AppFonts.primary,
    ),
  ),

  // Buttons: use surface as button background and primary as text color
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _appColors.onPrimary,
      foregroundColor: _appColors.primary,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: AppFonts.primary,
      ),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: _appColors.primary,
    contentTextStyle: TextStyle(
      color: _appColors.onPrimary,
      fontWeight: FontWeight.bold,
      fontFamily: AppFonts.primary,
    ),
    behavior: SnackBarBehavior.floating,
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: _appColors.onPrimary,
  ),

  iconTheme: IconThemeData(color: _appColors.onPrimary),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: _appColors.surface.withValues(alpha: 0.95),
    selectedIconTheme: IconThemeData(color: _appColors.onPrimary),
    unselectedIconTheme: IconThemeData(color: _appColors.primary),
    selectedItemColor: _appColors.onPrimary,
    unselectedItemColor: _appColors.primary,
    selectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  ),

  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      TargetPlatform.windows: ZoomPageTransitionsBuilder(),
    },
  ),
);

class NoScrollbarScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
