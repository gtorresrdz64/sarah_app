import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sarah_app/core/constants/app_colors.dart';

/// Claymorphism-inspired theme for Sarah App.
///
/// Rules from ui-ux-pro-max:
///  • border-radius: 20-24px
///  • border: 3-4px solid darker shade
///  • double shadows: inner (inset-like) + outer
///  • soft bounce press: 200ms ease-out
///  • pastel / vivid palette (Duolingo-style greens + sky blues)
class AppTheme {
  AppTheme._();

  static ThemeData get childTheme => _build(isChild: true);
  static ThemeData get parentTheme => _build(isChild: false);

  static ThemeData _build({required bool isChild}) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: isChild
          ? AppColors.childBackground
          : AppColors.parentBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: isChild ? AppColors.primary : AppColors.secondary,
        primary: isChild ? AppColors.primary : AppColors.secondary,
        secondary: AppColors.accent,
        surface: AppColors.cardWhite,
      ),

      // ── Typography ────────────────────────────────────────────────────────
      textTheme: TextTheme(
        // Big titles (¡Hola Sarah!)
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
          height: 1.1,
        ),
        // Task name
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        // Section labels
        bodyLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        // Supporting text
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        // Button labels
        labelLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 0.2,
        ),
      ),

      // ── ElevatedButton: clay-style ────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 72),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.primaryDark, width: 3),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.15),
            width: 2,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: isChild
            ? AppColors.childBackground
            : AppColors.parentBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }
}
