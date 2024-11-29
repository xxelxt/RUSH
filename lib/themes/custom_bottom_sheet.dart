import 'package:flutter/material.dart';

class CustomBottomSheet {
  static const BottomSheetThemeData bottomSheetThemeData = BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
  );
}
