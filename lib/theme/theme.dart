import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFFFFFF),
    primary: Color(0xFF6582AA),
    secondary: Color(0xFFA3C5F1),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);
