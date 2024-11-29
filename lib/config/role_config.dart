import 'package:flutter/material.dart';

abstract class RoleConfig {
  String appName() {
    return '';
  }

  Color primaryColor() {
    return Colors.green;
  }

  Color primaryDarkColor() {
    return Colors.greenAccent;
  }

  ThemeData theme() {
    return ThemeData.light();
  }

  ThemeData darkTheme() {
    return ThemeData.dark();
  }
}
