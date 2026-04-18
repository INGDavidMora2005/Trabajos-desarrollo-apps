import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        // Fuentes claras para marcadores de tiempo
        bodyLarge: TextStyle(fontFamily: 'monospace'),
        bodyMedium: TextStyle(fontFamily: 'monospace'),
        bodySmall: TextStyle(fontFamily: 'monospace'),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'monospace'),
        bodyMedium: TextStyle(fontFamily: 'monospace'),
        bodySmall: TextStyle(fontFamily: 'monospace'),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
