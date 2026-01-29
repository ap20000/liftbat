import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF10B981); // Emerald 500
  static const Color accent = Color(0xFFF59E0B); // Amber 500
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA);

  // Alert Status Colors
  static const Color critical = Color(0xFFEF4444); // Red 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Neutral Palette (Restored)
  static const Color textPrimary = Color(0xFF111827); // Gray 900
  static const Color textSecondary = Color(0xFF6B7280); // Gray 500
  static const Color textTertiary = Color(0xFF9CA3AF); // Gray 400
  static const Color divider = Color(0xFFF3F4F6); // Gray 100
  static const Color shadow = Color(0x0A000000);

  // Production Accent Palette
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color slateDark = Color(0xFF1E293B);
  static const Color cardShadow = Color(0x0A000000);
  static const Color modernBlue = Color(0xFF6366F1);
  static const Color modernPurple = Color(0xFFA855F7);
  static const Color modernPink = Color(0xFFFC466B);
  static const Color modernGold = Color(0xFFFFD700);

  // High-Fidelity Gradients
  static const LinearGradient escalationGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFC466B), Color(0xFF6366F1)],
  );

  static const LinearGradient actionGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
  );

  static const LinearGradient darkPanelGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFF9FAFB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
