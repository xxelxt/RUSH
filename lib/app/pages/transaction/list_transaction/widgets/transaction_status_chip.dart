import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:flutter/material.dart';

class TransactionStatusChip extends StatelessWidget {
  final int status; // Trạng thái giao dịch được truyền vào dưới dạng số nguyên.
  const TransactionStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.amber.shade100;
    Color textColor = Colors.amber.shade900;
    String labelText = 'Đang xử lý';

    // Tìm trạng thái giao dịch dựa trên giá trị số nguyên truyền vào
    TransactionStatus transactionStatus = TransactionStatus.values
        .where((element) => element.value == status)
        .first;

    switch (transactionStatus) {
      case TransactionStatus.processed:
        labelText = 'Đang xử lý';
        break;
      case TransactionStatus.sent:
        labelText = 'Đã gửi hàng';
        break;
      case TransactionStatus.arrived:
        labelText = 'Đã giao hàng';
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green;
        break;
      case TransactionStatus.done:
        labelText = 'Đã hoàn thành';
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green;
        break;
      case TransactionStatus.rejected:
        labelText = 'Không nhận hàng/Bị từ chối';
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red;
        break;
      case TransactionStatus.reviewed:
        labelText = 'Đã đánh giá';
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green;
        break;
      default:
    }

    return Chip(
      backgroundColor: backgroundColor,
      labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(vertical: -4),
      label: Text(labelText),
    );
  }
}
