import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:flutter/material.dart';

import '../../../../themes/custom_color.dart';
import '../../../constants/colors_value.dart';

class SelectPaymentMethod extends StatelessWidget {
  // Phương thức thanh toán hiện tại
  final PaymentMethod? paymentMethod;

  // Hàm callback khi chọn phương thức thanh toán khác
  final Function() selectPaymentMethod;

  // Hàm callback khi xóa phương thức thanh toán hiện tại
  final Function() removePaymentMethod;

  const SelectPaymentMethod({
    super.key,
    this.paymentMethod,
    required this.selectPaymentMethod,
    required this.removePaymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề và nút chọn phương thức thanh toán khác
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phương thức thanh toán',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // Hiển thị nút nếu có phương thức thanh toán
            if (paymentMethod != null)
              TextButton(
                onPressed: () {
                  selectPaymentMethod(); // Gọi hàm chọn phương thức thanh toán khác
                },
                child: const Text('Phương thức khác'),
              ),
          ],
        ),

        // Nút thêm phương thức thanh toán khi chưa có phương thức
        if (paymentMethod == null)
          TextButton.icon(
            onPressed: () {
              selectPaymentMethod(); // Gọi hàm chọn phương thức
            },
            icon: Icon(
              Icons.add_rounded,
              color: ColorsValue.primaryColor(context),
            ),
            label: const Text('Thêm phương thức'),
          ),

        // Hiển thị thông tin phương thức thanh toán khi đã có
        if (paymentMethod != null)
          ListTile(
            dense: true,
            title: Text(paymentMethod!.cardholderName),
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(vertical: -4),
            subtitle: Text(
              paymentMethod!.cardNumber,
            ),
            trailing: IconButton(
              onPressed: () {
                removePaymentMethod(); // Gọi hàm xóa phương thức thanh toán
              },
              icon: const Icon(
                Icons.clear_rounded,
                color: CustomColor.error,
              ),
            ),
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}
