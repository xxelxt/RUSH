import 'package:rush/app/providers/dark_mode_provider.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FlavorConfig flavor = FlavorConfig.instance;

class ColorsValue {
  static Color primaryColor(BuildContext context) {
    return context.read<DarkModeProvider>().isDarkMode
        ? flavor.flavorValues.roleConfig.primaryDarkColor()
        : flavor.flavorValues.roleConfig.primaryColor();}
}
