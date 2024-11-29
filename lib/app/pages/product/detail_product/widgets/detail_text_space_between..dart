// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DetailTextSpaceBetween extends StatelessWidget {
  final String leftText;
  final String rightText;
  const DetailTextSpaceBetween({super.key, required this.leftText, required this.rightText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          rightText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
