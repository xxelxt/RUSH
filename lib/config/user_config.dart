import 'package:rush/config/role_config.dart';
import 'package:rush/themes/custom_bottom_sheet.dart';
import 'package:rush/themes/custom_input_decoration.dart';
import 'package:rush/themes/custom_text_theme.dart';
import 'package:flutter/material.dart';

class UserConfig implements RoleConfig {
  @override
  String appName() {
    return 'RUSH';
  }

  @override
  Color primaryColor() {
    return const Color(0xFF634832);
  }

  @override
  Color primaryDarkColor() {
    return const Color(0xFF967259);
  }

  @override
  ThemeData theme() {
    return ThemeData(
      primaryColor: primaryColor(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor(),
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
      useMaterial3: true,
      textTheme: CustomTextTheme.textTheme,
      inputDecorationTheme: CustomInputDecoration.inputDecorationTheme,
      bottomSheetTheme: CustomBottomSheet.bottomSheetThemeData,
    );
  }
}
