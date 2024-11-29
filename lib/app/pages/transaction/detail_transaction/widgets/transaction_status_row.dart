import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:flutter/material.dart';

class TransactionStatusRow extends StatelessWidget {
  final int status;
  final String transactionID;
  const TransactionStatusRow({super.key, required this.status, required this.transactionID});

  @override
  Widget build(BuildContext context) {
    String statusText = 'Processed';
    Color statusColor = Colors.amber.shade900;

    TransactionStatus transactionStatus = TransactionStatus.values.where((element) => element.value == status).first;

    switch (transactionStatus) {
      case TransactionStatus.processed:
        statusText = 'Processed';
        break;
      case TransactionStatus.sent:
        statusText = 'Sent';
        break;
      case TransactionStatus.arrived:
        statusText = 'Arrived';
        statusColor = Colors.green;
        break;
      case TransactionStatus.done:
        statusText = 'Done';
        statusColor = Colors.green;
        break;
      case TransactionStatus.rejected:
        statusText = 'Rejected';
        statusColor = Colors.red;
        break;
      case TransactionStatus.reviewed:
        statusText = 'Reviewed';
        statusColor = Colors.green;
        break;
      default:
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: 3,
          ),
          const SizedBox(width: 4.0),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              transactionID,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
