// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // ========================
  // Display
  // ========================

  static TextStyle get displayLarge => GoogleFonts.cairo(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  // ========================
  // Headings
  // ========================

  static TextStyle get headingLarge => GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle get headingMedium => GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle get headingSmall => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // ========================
  // Body
  // ========================

  static TextStyle get bodyLarge => GoogleFonts.cairo(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get bodySmall => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  // ========================
  // Buttons
  // ========================

  static TextStyle get button => GoogleFonts.cairo(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // ========================
  // Price
  // ========================

  static TextStyle get price => GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: const Color(0xffB60F1A),
  );

  // ========================
  // Caption
  // ========================

  static TextStyle get caption => GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );
}
