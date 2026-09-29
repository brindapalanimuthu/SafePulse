import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SosColors {
  static const black = Color(0xFF000000);
  static const red = Color(0xFFE11D2A);
  static const redDeep = Color(0xFFA30F19);
  static const canvas = Color(0xFFF4F4F6);
  static const surface = Colors.white;
  static const ink = Color(0xFF0A0A0A);
  static const muted = Color(0xFF8E8E93);
  static const line = Color(0xFFEDEDF0);
}

class SosText {
  /// Condensed, heavy headline face (the "SOS" / "ALEX" look).
  static TextStyle display(double size, {Color color = SosColors.ink}) =>
      GoogleFonts.anton(fontSize: size, height: 1.0, letterSpacing: 0.4, color: color);

  static TextStyle body(double size,
          {Color color = SosColors.ink, FontWeight weight = FontWeight.w400, double? spacing}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color, letterSpacing: spacing, height: 1.35);
}
