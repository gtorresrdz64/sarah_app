import 'package:flutter/material.dart';

/// Claymorphism-inspired palette for Sarah App.
///
/// Primary:    Vivid unisex purple/violet  — energy, achievement
/// Secondary:  Soft indigo/lavender        — calm, trust
/// Accent:     Sunny golden yellow         — joy, highlight
/// Clay pink:  Warm rose/pink              — friendliness, warmth
/// Background: Soft purple/lavender tint   — depth and kid-friendly aesthetic
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF8B5CF6); // Vivid purple
  static const Color primaryDark = Color(0xFF7C3AED); // pressed / shadow tone
  static const Color secondary = Color(0xFF818CF8); // Soft indigo/lavender
  static const Color secondaryDark = Color(0xFF4F46E5);
  static const Color accent = Color(0xFFFBBF24); // sunny golden yellow
  static const Color pink = Color(0xFFF472B6); // clay rose-pink

  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFAF5FF); // soft lavender-white
  static const Color childBackground = Color(0xFFFAF5FF);
  static const Color parentBackground = Color(0xFFF3F4F6);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF34D399); // minty success green
  static const Color successDark = Color(0xFF059669);
  static const Color warning = Color(0xFFFF9600);
  static const Color error = Color(0xFFFF4B4B);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2E1065); // deep purple-indigo
  static const Color textSecondary = Color(0xFF7C3AED); // medium purple/violet
  static const Color white = Color(0xFFFFFFFF);

  // ── Clay shadow tones (for double-shadow effect) ───────────────────────────
  static const Color shadowOuter = Color(0x33000000); // 20 % black
  static const Color shadowInner = Color(0x22FFFFFF); // 13 % white
}
