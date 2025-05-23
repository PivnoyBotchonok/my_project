import 'package:flutter/material.dart';

class AppTheme {
  static Color successColor(Brightness brightness) =>
      brightness == Brightness.dark ? Colors.lightGreenAccent : Colors.green;

  static Color errorColor(Brightness brightness) =>
      brightness == Brightness.dark ? Colors.redAccent : Colors.red;
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: Colors.orangeAccent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.orangeAccent,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.orangeAccent),
      bodyMedium: TextStyle(color: Colors.orangeAccent),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.orangeAccent,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.orangeAccent,
        side: const BorderSide(color: Colors.orangeAccent),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.orangeAccent,
    ),
  );
}
