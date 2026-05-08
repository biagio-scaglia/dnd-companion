import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.highlight,
        secondary: AppColors.magicAccent,
        tertiary: AppColors.naturalAccent,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.danger,
        onPrimary: AppColors.background,
        onSecondary: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        labelLarge: TextStyle(color: AppColors.highlight, fontWeight: FontWeight.w600),
      ),
      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Navigation Bar (Mobile)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.highlight.withOpacity(0.15),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(color: AppColors.highlight, fontSize: 12, fontWeight: FontWeight.bold);
          }
          return const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500);
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.highlight);
          }
          return const IconThemeData(color: AppColors.textSecondary);
        }),
      ),
      // Navigation Rail (Tablet/Desktop)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.background,
        selectedIconTheme: const IconThemeData(color: AppColors.highlight),
        unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary),
        selectedLabelTextStyle: const TextStyle(color: AppColors.highlight, fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        useIndicator: true,
        indicatorColor: AppColors.highlight.withOpacity(0.15),
      ),
    );
  }
}
