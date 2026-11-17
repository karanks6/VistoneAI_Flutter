import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme getTheme(Color displayColor, Color bodyColor) {
    final body = GoogleFonts.interTextTheme();
    return body.copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 42,
        fontWeight: FontWeight.w400,
        height: 1.08,
        letterSpacing: -0.6,
        color: displayColor,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: -0.4,
        color: displayColor,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.15,
        letterSpacing: -0.2,
        color: displayColor,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.18,
        color: displayColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.2,
        color: displayColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.1,
        color: displayColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: displayColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: bodyColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: bodyColor,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: bodyColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: bodyColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: bodyColor,
      ),
    );
  }
}
