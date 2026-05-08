import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getTheme({required String accentColor}) {
    Color primaryColor;
    switch (accentColor) {
      case 'nature':
        primaryColor = AppColors.naturalAccent;
        break;
      case 'highlight':
        primaryColor = AppColors.highlight;
        break;
      case 'magic':
      default:
        primaryColor = AppColors.magicAccent;
    }

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: AppColors.naturalAccent,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: AppTypography.h2,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.cinzel(textStyle: AppTypography.h1),
        headlineMedium: GoogleFonts.cinzel(textStyle: AppTypography.h2),
        titleMedium: GoogleFonts.cinzel(textStyle: AppTypography.h3),
        bodyLarge: GoogleFonts.almendra(textStyle: AppTypography.body),
        bodyMedium: GoogleFonts.almendra(textStyle: AppTypography.bodySmall),
        labelLarge: GoogleFonts.cinzel(textStyle: AppTypography.label),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lBorderRadius,
          side: const BorderSide(color: AppColors.surfaceSecondary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.background,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mBorderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
