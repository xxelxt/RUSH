import 'package:rush/app/pages/transaction/detail_transaction/widgets/selected_shipping_address.dart';
import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

class OrderSummaryColumn extends StatelessWidget {
  final int countItems;
  final double totalPrice;
  final double shippingFee;
  final Address shippingAddress;

  const OrderSummaryColumn({
    super.key,
    required this.countItems,
    required this.totalPrice,
    required this.shippingFee,
    required this.shippingAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tóm tắt đơn hàng',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),

        // Hiển thị thông tin chi tiết của địa chỉ giao hàng
        SelectedShippingAddress(
          shippingAddress: shippingAddress,
        ),
        const SizedBox(height: 8),

        // Hiển thị tổng giá trị đơn hàng
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng giá trị ($countItems sản phẩm)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              totalPrice.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),

        // Hiển thị phí giao hàng
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phí giao hàng',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              shippingFee.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ],
    );
  }
}
