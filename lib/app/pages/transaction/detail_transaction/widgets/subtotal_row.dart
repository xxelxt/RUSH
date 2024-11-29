import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

class SubtotalRow extends StatelessWidget {
  final double subtotal;
  const SubtotalRow({super.key, required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Subtotal',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          subtotal.toCurrency(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
