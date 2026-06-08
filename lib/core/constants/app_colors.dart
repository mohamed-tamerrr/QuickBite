import 'dart:ui';

class AppColors {
  // Main Brand Color
  static const Color primary = Color(0xffD97706);

  // Variations
  static const Color primaryLight = Color(0xffF59E0B);
  static const Color primaryDark = Color(0xffB45309);

  // Backgrounds
  static const Color background = Color(0xffFFF8F1);
  static const Color card = Color(0xffFFFFFF);

  // Text
  static const Color textPrimary = Color(0xff1F2937);
  static const Color textSecondary = Color(0xff6B7280);

  // Accent
  static const Color accent = Color(0xff22C55E);
  static const List<Color> gradientsPrimary = [
    AppColors.primary,
    AppColors.primaryDark,
  ];
}
