import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFFFFFF),
    primary: Color.fromARGB(255, 103, 6, 164),
    secondary: Color.fromARGB(255, 57, 26, 120),
    tertiary: Color.fromARGB(255, 137, 79, 190),
  ),
  primaryTextTheme: GoogleFonts.comfortaaTextTheme(),
  textTheme: GoogleFonts.poppinsTextTheme(),
);