import 'package:flutter/material.dart';

class AppTheme {
  // The "Midnight VIP" Palette
  static const Color primaryVibrantAccent = Color(0xFF6366F1); // Electric Indigo
  static const Color secondaryUrgentAccent = Color(0xFFF43F5E); // Vibrant Rose (replaces harsh green)
  
  static const Color backgroundDark = Color(0xFF0C0C14); // Deep Space Black
  static const Color surfaceGlass = Color(0x331E1E2E); // Sleek Slate Glass
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF); // Subdued Gray

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryVibrantAccent,
      colorScheme: const ColorScheme.dark(
        primary: primaryVibrantAccent,
        secondary: secondaryUrgentAccent, // Rose injected as secondary
        surface: surfaceGlass,
        background: backgroundDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryVibrantAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 20,
          shadowColor: primaryVibrantAccent.withOpacity(0.4),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1),
        titleLarge: TextStyle(color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 16),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundDark, // True Deep Black Bar
        selectedItemColor: primaryVibrantAccent,
        unselectedItemColor: textSecondary,
        selectedIconTheme: IconThemeData(size: 32),
        unselectedIconTheme: IconThemeData(size: 28),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}

