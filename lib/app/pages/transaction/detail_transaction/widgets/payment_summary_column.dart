import 'package:rush/app/pages/transaction/detail_transaction/widgets/selected_payment_method.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

class PaymentSummaryColumn extends StatelessWidget {
  final double totalBill;
  final double serviceFee;
  final double totalPay;
  final PaymentMethod paymentMethod;

  const PaymentSummaryColumn({
    super.key,
    required this.totalBill,
    required this.serviceFee,
    required this.totalPay,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin thanh toán',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),

        // Hiển thị thông tin của phương thức thanh toán được truyền vào
        SelectedPaymentMethod(
          paymentMethod: paymentMethod,
        ),
        const SizedBox(height: 8),

        // Hiển thị tổng giá trị đơn hàng
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng giá trị đơn hàng',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              totalBill.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),

        // Hiển thị phí dịch vụ
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phí dịch vụ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              serviceFee.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Hiển thị tổng tiền phải trả
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng tiền phải trả',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              totalPay.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ],
    );
  }
}
