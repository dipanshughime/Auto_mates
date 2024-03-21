import "package:flutter/material.dart";

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 249, 249, 249),
      colorScheme: const ColorScheme.light());

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light());
}
