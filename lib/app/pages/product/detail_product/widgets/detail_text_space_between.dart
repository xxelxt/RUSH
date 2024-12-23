// ignore_for_file: file_names

import 'package:flutter/material.dart';

// Hiển thị hai chuỗi văn bản căn đều hai bên trong một hàng ngang
class DetailTextSpaceBetween extends StatelessWidget {
  final String leftText;
  final String rightText;

  const DetailTextSpaceBetween({
    super.key,
    required this.leftText, // Văn bản bên trái
    required this.rightText, // Văn bản bên phải
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều hai đầu
      children: [
        // Văn bản bên trái
        Text(
          leftText,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold, // Kiểu chữ đậm
          ),
        ),

        // Văn bản bên phải
        Text(
          rightText,
          style: Theme.of(context).textTheme.bodyLarge, // Kiểu chữ bình thường
        ),
      ],
    );
  }
}
