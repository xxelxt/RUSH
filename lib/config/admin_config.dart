import 'package:rush/config/role_config.dart';
import 'package:rush/themes/custom_bottom_sheet.dart';
import 'package:rush/themes/custom_text_theme.dart';
import 'package:flutter/material.dart';

import '../themes/custom_input_decoration.dart';

class AdminConfig implements RoleConfig {
  // TODO: Change Admin App Name
  @override
  String appName() {
    return 'RUSH-ing';
  }

  // TODO: Change App Primary Color
  @override
  Color primaryColor() {
    return const Color(0xFF288364);
  }

  // TODO: Change App Primary Dark Color
  @override
  Color primaryDarkColor() {
    return const Color(0xFF4E9F3D);
  }

  @override
  ThemeData theme() {
    return ThemeData(
      primaryColor: primaryColor(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor(),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor(),
      ),
      useMaterial3: true,
      textTheme: CustomTextTheme.textTheme,
      inputDecorationTheme: CustomInputDecoration.inputDecorationTheme,
      bottomSheetTheme: CustomBottomSheet.bottomSheetThemeData,
    );
  }

  @override
  ThemeData darkTheme() {
    return ThemeData(
      primaryColorDark: primaryDarkColor(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDarkColor(),
        brightness: Brightness.dark,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryDarkColor(),
      ),
      useMaterial3: true,
      textTheme: CustomTextTheme.textTheme,
      inputDecorationTheme: CustomInputDecoration.inputDecorationTheme,
      bottomSheetTheme: CustomBottomSheet.bottomSheetThemeData,
    );
  }
}
