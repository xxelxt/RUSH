import 'package:rush/app/pages/transaction/detail_transaction/widgets/transaction_status_checkbox.dart';
import 'package:rush/app/providers/transaction_provider.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminActionTransactionButton extends StatelessWidget {
  final String transactionID;
  final int transactionStatus;

  const AdminActionTransactionButton({
    super.key,
    required this.transactionStatus,
    required this.transactionID,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định trạng thái hiện tại của đơn hàng dựa trên transactionStatus
    TransactionStatus status = TransactionStatus.values
        .where((element) => element.value == transactionStatus)
        .first;

    void Function()? onPressed;

    String labelText = '';

    switch (status) {
      case TransactionStatus.done:
        labelText = 'Đã hoàn thành';
        // Không cần hành động khi trạng thái đã hoàn thành
        break;
      case TransactionStatus.reviewed:
        labelText = 'Đã đánh giá';
        // Không cần hành động khi trạng thái đã đánh giá
        break;
      default:
        labelText = 'Thay đổi trạng thái';
        // Hiển thị hộp thoại thay đổi trạng thái khi nhấn nút
        onPressed = () async {
          await showModalBottomSheet<TransactionStatus>(
            context: context,
            builder: (context) {
              return TransactionStatusCheckbox(selectedStatus: status);
              // Hiển thị danh sách trạng thái để admin chọn
            },
          ).then((status) {
            if (status != null) {
              // Gửi yêu cầu thay đổi trạng thái đến TransactionProvider
              context.read<TransactionProvider>().changeStatus(
                transactionID: transactionID,
                status: status.value,
              );
            }
          });
        };
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
      child: ElevatedButton(
        onPressed: onPressed, // Gọi hàm `onPressed` nếu không null
        child: Text(labelText),
      ),
    );
  }
}
