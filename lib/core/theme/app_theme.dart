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

    final base = TextTheme(
      displayLarge: AppTypography.display,
      headlineLarge: AppTypography.h1,
      headlineMedium: AppTypography.h2,
      titleMedium: AppTypography.h3,
      titleSmall: AppTypography.subtitle,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.bodySmall,
      labelLarge: AppTypography.label,
      labelSmall: AppTypography.caption,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: AppColors.naturalAccent,
        surface: AppColors.surface,
        // FIX: 'background' deprecato → rimosso, 'surface' è il sostituto
        error: AppColors.danger,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: base,
      primaryTextTheme: base,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lBorderRadius,
          side: const BorderSide(color: AppColors.surfaceSecondary),
        ),
      ),

      // Input (TextField, TextFormField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: AppTypography.bodySmall,
        // FIX: withOpacity → withValues
        hintStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mBorderRadius,
          borderSide: const BorderSide(color: AppColors.surfaceSecondary, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mBorderRadius,
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mBorderRadius,
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mBorderRadius,
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.background,
          textStyle: const TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold, fontSize: 13),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mBorderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 0,
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold, fontSize: 13),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mBorderRadius),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceSecondary,
        thickness: 1,
        space: 1,
      ),

      // BottomNavigationBar / NavigationBar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        // FIX: withOpacity → withValues
        indicatorColor: primaryColor.withValues(alpha: 0.15),
        // FIX: MaterialStateProperty → WidgetStateProperty, MaterialState → WidgetState
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primaryColor, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontFamily: 'Cinzel',
              color: primaryColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            );
          }
          return const TextStyle(
            fontFamily: 'Cinzel',
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          );
        }),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
      ),

      // NavigationRail
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        // FIX: withOpacity → withValues
        indicatorColor: primaryColor.withValues(alpha: 0.15),
        selectedIconTheme: IconThemeData(color: primaryColor, size: 24),
        unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),
        selectedLabelTextStyle: TextStyle(
          fontFamily: 'Cinzel',
          color: primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
        useIndicator: true,
        elevation: 0,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        subtitleTextStyle: AppTypography.bodySmall,
        titleTextStyle: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mBorderRadius),
      ),

      // Switch
      // FIX: MaterialStateProperty → WidgetStateProperty, MaterialState → WidgetState
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.background;
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return AppColors.surfaceSecondary;
        }),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lBorderRadius,
          side: const BorderSide(color: AppColors.surfaceSecondary),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: AppTypography.body,
      ),
    );
  }
}
