import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFB60F1A);
  static const Color primaryDark = Color(0xFF900B15);
  static const Color primaryLight = Color(0xFFFBEAEC);
  static const Color secondary = Color(0xFFD99A32);

  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color canvas = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);

  // Text
  static const Color textPrimary = Color(0xFF242424);
  static const Color textSecondary = Color(0xFF868686);
  static const Color textMuted = Color(0xFFAAAAAA);

  // Borders
  static const Color border = Color(0xFFEAE6E0);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Backward compatibility
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
}
