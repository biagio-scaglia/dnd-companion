import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

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
      textTheme: const TextTheme(
        headlineLarge: AppTypography.h1,
        headlineMedium: AppTypography.h2,
        titleMedium: AppTypography.h3,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.bodySmall,
        labelLarge: AppTypography.label,
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
