import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFF000000),
    primary: Color(0xFF6582AA),
    secondary: Color(0xFFA3C5F1),
    tertiary: Color(0xFFB2B7BF),
  ),
  primaryTextTheme: GoogleFonts.comfortaaTextTheme(),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF000000),
    onBackground: Color(0xFFFFFFFF),
    primary: Color(0xFF6582AA),
    secondary: Color(0xFFA3C5F1),
    tertiary: Color(0xFFB2B7BF),
  ),
  primaryTextTheme: GoogleFonts.comfortaaTextTheme(),
  textTheme: GoogleFonts.poppinsTextTheme(),
);
