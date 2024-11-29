import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextTheme {
  // TODO: Change font here
  static TextTheme textTheme = GoogleFonts.openSansTextTheme().copyWith(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
    headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
    headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
    titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
  );
}
