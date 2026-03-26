// lib/utils/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color inkDark = Color(0xFF1A1208);
  static const Color paperWarm = Color(0xFFF5F0E8);
  static const Color creamLight = Color(0xFFEDE8DA);
  static const Color accentRed = Color(0xFFC0392B);
  static const Color goldAccent = Color(0xFFB8860B);
  static const Color mutedBrown = Color(0xFF7A6E5A);
  static const Color spineNavy = Color(0xFF2C3E50);
  static const Color spineCrimson = Color(0xFF6B2D3E);
  static const Color spineForest = Color(0xFF1B4332);
  static const Color spineAmber = Color(0xFF7B3F00);
  static const Color spineIndigo = Color(0xFF2D3561);
  static const Color spinePlum = Color(0xFF4A1942);
  static const Color woodBrown = Color(0xFF2C1810);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.accentRed,
        secondary: AppColors.goldAccent,
        surface: AppColors.paperWarm,
        onSurface: AppColors.inkDark,
      ),
      scaffoldBackgroundColor: AppColors.creamLight,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.inkDark,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.inkDark,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.inkDark,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.inkDark,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.inkDark,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.inkDark,
          height: 1.7,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.mutedBrown,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
          color: AppColors.mutedBrown,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.woodBrown,
        foregroundColor: AppColors.paperWarm,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.paperWarm,
        ),
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.woodBrown,
        indicatorColor: AppColors.accentRed.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.dmSans(fontSize: 10, color: AppColors.paperWarm),
        ),
      ),
    );
  }
}
