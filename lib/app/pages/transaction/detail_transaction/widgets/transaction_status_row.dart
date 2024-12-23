import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:flutter/material.dart';

class TransactionStatusRow extends StatelessWidget {
  final int status;
  final String transactionID;
  const TransactionStatusRow({super.key, required this.status, required this.transactionID});

  @override
  Widget build(BuildContext context) {
    String statusText = 'Đang xử lý';
    Color statusColor = Colors.amber.shade900;

    TransactionStatus transactionStatus =
        TransactionStatus.values.where((element) => element.value == status).first;

    switch (transactionStatus) {
      case TransactionStatus.processed:
        statusText = 'Đang xử lý';
        break;
      case TransactionStatus.sent:
        statusText = 'Đã gửi hàng';
        break;
      case TransactionStatus.arrived:
        statusText = 'Đã giao hàng';
        statusColor = Colors.green;
        break;
      case TransactionStatus.done:
        statusText = 'Đã hoàn thành';
        statusColor = Colors.green;
        break;
      case TransactionStatus.rejected:
        statusText = 'Không nhận hàng/Bị từ chối';
        statusColor = Colors.red;
        break;
      case TransactionStatus.reviewed:
        statusText = 'Đã đánh giá';
        statusColor = Colors.green;
        break;
      default:
    }

    // Hiển thị giao diện cho trạng thái và ID giao dịch
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Màu thể hiện trạng thái
          Container(
            decoration: BoxDecoration(
              color: statusColor, // Màu sắc tùy thuộc vào trạng thái
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: 3,
          ),
          const SizedBox(width: 4.0),

          // Văn bản trạng thái đơn hàng
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Text(
              transactionID,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
