import 'package:flutter/material.dart';

class CustomTextTheme {
  // Sử dụng font Be Vietnam Pro
  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 32, fontWeight: FontWeight.normal),
    headlineMedium: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 28, fontWeight: FontWeight.normal),
    headlineSmall: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 24, fontWeight: FontWeight.normal),
    titleLarge: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 16, fontWeight: FontWeight.normal),
    titleSmall: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 14, fontWeight: FontWeight.w300),
    bodyLarge: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 12, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 14, fontWeight: FontWeight.bold),
    labelMedium: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 12, fontWeight: FontWeight.normal),
    labelSmall: TextStyle(
        fontFamily: 'BeVietnamPro', fontSize: 11, fontWeight: FontWeight.normal),
  );
}