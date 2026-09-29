import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide theme for the existing screens (Countdown, Classification, etc.).
/// The new SOS screens use theme/sos_theme.dart instead.
class AppTheme {
  static const Color _seed = Color(0xFFE11D2A);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: b),
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
