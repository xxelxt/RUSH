import 'package:rush/themes/custom_color.dart';
import 'package:flutter/material.dart';

errorBanner({required BuildContext context, required String msg}) {
  return MaterialBanner(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),
    contentTextStyle: const TextStyle(color: Colors.white),
    content: Text(msg),
    backgroundColor: CustomColor.error,
    actions: [
      // Nút hành động cho thông báo
      InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        },
        child: const Text(
          "Xoá thông báo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
