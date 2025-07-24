import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class AppTheme {
  // GitCitadel Brand Colors
  static const Color brandPurple = Color(0xFFA7A8FF);
  static const Color brandPurpleLight = Color(0xFFB8B9FF);
  static const Color brandPurpleDark = Color(0xFF8B8CFF);
  static const Color brandGradientStart = Color(0xFFFFFFFF);
  static const Color brandGradientEnd = Color(0xFFA7A8FF);
  
  // Vibrant Accent Colors
  static const Color accentTurquoise = Color(0xFF00D4AA);
  static const Color accentHotPink = Color(0xFFFF6B9D);
  static const Color accentOrange = Color(0xFFFF8A65);
  static const Color accentBlue = Color(0xFF4FC3F7);
  
  // Dark theme colors (GitCitadel inspired) - Improved contrast
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFCCCCCC); // Improved contrast
  static const Color darkPrimary = brandPurple;
  static const Color darkAccent = Color(0xFF6C63FF);

  // Light theme colors (GitCitadel inspired) - Improved contrast
  static const Color lightBackground = Color(0xFFE8E8E8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF8F9FF);
  static const Color lightText = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF444444); // Improved contrast
  static const Color lightPrimary = brandPurple;
  static const Color lightAccent = Color(0xFF6C63FF);

  // Gradient for brand elements
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandGradientStart, brandGradientEnd],
  );
  
  // Vibrant gradient for "GitCitadel" text
  static const LinearGradient gitcitadelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandPurpleDark, brandPurple, Color(0xFF90EE90)],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: darkBackground,
        surface: darkSurface,
        primary: darkPrimary,
        secondary: darkAccent,
        onBackground: darkText,
        onSurface: darkText,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardTheme: CardTheme(
        color: darkCard,
        elevation: 4,
        shadowColor: brandPurple.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: darkText,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: darkText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: darkText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: darkTextSecondary,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentTurquoise, width: 2),
        ),
        hintStyle: const TextStyle(color: darkTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: brandPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: accentTurquoise,
        size: 24,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        background: lightBackground,
        surface: lightSurface,
        primary: lightPrimary,
        secondary: lightAccent,
        onBackground: lightText,
        onSurface: lightText,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: lightBackground,
      cardTheme: CardTheme(
        color: lightCard,
        elevation: 2,
        shadowColor: brandPurple.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFAAAAAA),
            width: 1.5,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: lightText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: lightText,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: lightText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: lightText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: lightTextSecondary,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentHotPink, width: 2),
        ),
        hintStyle: const TextStyle(color: lightTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: brandPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: accentHotPink,
        size: 24,
      ),
    );
  }
} 