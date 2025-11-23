import 'dart:ui';

class AppColors {
  // Primary
  static const Color primaryColor = Color(0xFF215E68); // الأساسي
  static const Color primaryVariant = Color(
    0x2C8D82FF,
  ); // أغمق شوي للضغط / hover

  // Secondary (مستخرج من درجة أفتح من الأساسي)
  static const Color secondaryColor = Color(0xFF3B7C88);
  static const Color secondaryVariant = Color(0xFF5BA0AD);

  // Backgrounds (فاتحة جداً لتفتح النفس)
  static const Color backgroundLight = Color(0xfff3f4f6);
  static const Color background = Color(0xfff3f4f6);
  static const Color surfaceLight = Color(0xFFE0EFF1);
  static const Color cardLight = Color(0xFFE0EFF1);
  static const Color dialogLight = Color(0xFFE0EFF1);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1C4349); // أغمق لقراءة قوية
  static const Color textSecondaryLight = Color(0xFF37646B); // أخف شوية
  static const Color textDisabledLight = Color(0xFF7DA1A6); // رمادي مائل للأزرق

  // Borders & Dividers
  static const Color borderLight = Color(0xFFD1E5E7);
  static const Color dividerLight = Color(0xFFAECED1);

  // On Colors
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF1C4349);
  static const Color onSurfaceLight = Color(0xFF1C4349);

  // Status Colors
  static const Color errorLight = Color(0xFFD75454);
  static const Color successLight = Color(0xFF1FAC82);
  static const Color warningLight = Color(0xFFE6A43B);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // Shadows
  static const Color shadowLight = Color(0x1A000000); // 10% opacity
}
