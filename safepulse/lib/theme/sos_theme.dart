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
  /// Current language code. Set by SafePulseApp whenever the locale changes.
  /// Anton and Inter have no Indic glyphs, so non-English locales use the
  /// matching Noto Sans script font instead.
  static String lang = 'en';

  static bool get _indic => const {'hi', 'ta', 'te', 'kn', 'bn'}.contains(lang);

  static TextStyle _noto(double size, Color color, FontWeight weight, double height) {
    switch (lang) {
      case 'hi':
        return GoogleFonts.notoSansDevanagari(fontSize: size, color: color, fontWeight: weight, height: height);
      case 'ta':
        return GoogleFonts.notoSansTamil(fontSize: size, color: color, fontWeight: weight, height: height);
      case 'te':
        return GoogleFonts.notoSansTelugu(fontSize: size, color: color, fontWeight: weight, height: height);
      case 'kn':
        return GoogleFonts.notoSansKannada(fontSize: size, color: color, fontWeight: weight, height: height);
      default:
        return GoogleFonts.notoSansBengali(fontSize: size, color: color, fontWeight: weight, height: height);
    }
  }

  /// Condensed, heavy headline face (the "SOS" / "ALEX" look).
  static TextStyle display(double size, {Color color = SosColors.ink}) => _indic
      ? _noto(size * 0.85, color, FontWeight.w800, 1.25)
      : GoogleFonts.anton(fontSize: size, height: 1.0, letterSpacing: 0.4, color: color);

  static TextStyle body(double size,
          {Color color = SosColors.ink, FontWeight weight = FontWeight.w400, double? spacing}) =>
      _indic
          // letterSpacing is dropped for Indic scripts: it breaks conjuncts.
          ? _noto(size, color, weight, 1.5)
          : GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color, letterSpacing: spacing, height: 1.35);

  /// Applies the script font to Material widgets (snackbars, fields, chips...).
  static ThemeData themed(ThemeData t, String code) {
    final TextStyle font;
    switch (code) {
      case 'hi':
        font = GoogleFonts.notoSansDevanagari();
        break;
      case 'ta':
        font = GoogleFonts.notoSansTamil();
        break;
      case 'te':
        font = GoogleFonts.notoSansTelugu();
        break;
      case 'kn':
        font = GoogleFonts.notoSansKannada();
        break;
      case 'bn':
        font = GoogleFonts.notoSansBengali();
        break;
      default:
        return t;
    }
    return t.copyWith(
      textTheme: t.textTheme.apply(fontFamily: font.fontFamily),
    );
  }
}