import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  // Display – hero sections, grandi header di pagina
  static TextStyle get display => const TextStyle(
        fontFamily: 'Cinzel',
        color: AppColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      );

  // H1 – titoli principali di sezione
  static TextStyle get h1 => const TextStyle(
        fontFamily: 'Cinzel',
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      );

  // H2 – titoli di card o sub-sezione
  static TextStyle get h2 => const TextStyle(
        fontFamily: 'Cinzel',
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  // H3 – titoli interni, dialogo
  static TextStyle get h3 => const TextStyle(
        fontFamily: 'Cinzel',
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  // Subtitle – descrizioni brevi sotto i titoli
  static TextStyle get subtitle => const TextStyle(
        fontFamily: 'Almendra',
        color: AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  // Body – testo normale
  static TextStyle get body => const TextStyle(
        fontFamily: 'Almendra',
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  // Body Small – testo secondario, meta-info
  static TextStyle get bodySmall => const TextStyle(
        fontFamily: 'Almendra',
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.4,
      );

  // Label – uppercase capsule label, chip, badge
  static TextStyle get label => const TextStyle(
        fontFamily: 'Cinzel',
        color: AppColors.textSecondary,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      );

  // Caption – metadata minimale
  static TextStyle get caption => const TextStyle(
        fontFamily: 'Almendra',
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.3,
      );

  // Section label – titolo di sezione uppercase con accento
  static TextStyle sectionLabel({Color color = AppColors.textSecondary}) =>
      TextStyle(
        fontFamily: 'Cinzel',
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      );
}
