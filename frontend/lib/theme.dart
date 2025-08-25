import 'package:flutter/material.dart';

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
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: _appColors.onPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: _appColors.onPrimary,
    ),
  ),

  // Buttons: use surface as button background and primary as text color
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _appColors.primary,
      foregroundColor: _appColors.onPrimary,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: _appColors.primary,
    contentTextStyle: TextStyle(
      color: _appColors.onPrimary,
      fontWeight: FontWeight.bold,
    ),
    behavior: SnackBarBehavior.floating,
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: _appColors.onPrimary,
  ),

  iconTheme: IconThemeData(color: _appColors.onPrimary),
);
