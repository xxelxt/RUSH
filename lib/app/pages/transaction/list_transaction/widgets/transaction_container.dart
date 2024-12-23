import 'package:rush/app/pages/transaction/list_transaction/widgets/transaction_product_container.dart';
import 'package:rush/app/pages/transaction/list_transaction/widgets/transaction_status_chip.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionContainer extends StatelessWidget {
  final Transaction item; // Đối tượng giao dịch được truyền vào.

  const TransactionContainer({super.key, required this.item}); // Nhận giao dịch vừa truyền vào làm tham số

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Điều hướng đến màn hình chi tiết giao dịch khi người dùng nhấn vào container
        NavigateRoute.toDetailTransaction(context: context, transactionID: item.transactionId);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Phần thông tin trên cùng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hiển thị tên khách hàng và ngày giao dịch
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item.account?.fullName ?? '',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: item.account != null ? ' - ' : '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Hiển thị trạng thái giao dịch (VD: Đang xử lý, Đã hoàn thành,...)
              TransactionStatusChip(status: item.transactionStatus!),
            ],
          ),

          // Phần hiển thị thông tin sản phẩm
          TransactionProductContainer(
            item: item.purchasedProduct.first, // Thông tin sản phẩm đầu tiên của giao dịch
            countOtherItems: item.purchasedProduct.length - 1, // Số lượng sản phẩm còn lại (nếu có nhiều hơn 1 sản phẩm)
            totalPay: item.totalPay!, // Tổng số tiền thanh toán của giao dịch
          ),
        ],
      ),
    );
  }
}
