import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:flutter/material.dart';

class TransactionStatusChip extends StatelessWidget {
  final int status;
  const TransactionStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.amber.shade100;
    Color textColor = Colors.amber.shade900;
    String labelText = 'Processed';
    TransactionStatus transactionStatus = TransactionStatus.values.where((element) => element.value == status).first;

    switch (transactionStatus) {
      case TransactionStatus.processed:
        labelText = 'Processed';
        break;
      case TransactionStatus.sent:
        labelText = 'Sent';
        break;
      case TransactionStatus.arrived:
        labelText = 'Arrived';
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green;
        break;
      case TransactionStatus.done:
        labelText = 'Done';
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green;
        break;
      case TransactionStatus.rejected:
        labelText = 'Rejected';
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red;
        break;
      case TransactionStatus.reviewed:
        labelText = 'Reviewed';
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green;
        break;
      default:
    }

    return Chip(
      backgroundColor: backgroundColor,
      labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: textColor, fontWeight: FontWeight.w500),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(vertical: -4),
      label: Text(labelText),
    );
  }
}
