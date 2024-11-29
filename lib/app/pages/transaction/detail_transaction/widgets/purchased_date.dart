import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchasedDate extends StatelessWidget {
  final DateTime date;
  const PurchasedDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Purchased Date',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          DateFormat('dd MMMM yyyy, HH:mm').format(date),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
