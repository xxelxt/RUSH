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
          'Order Summary',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        SelectedShippingAddress(
          shippingAddress: shippingAddress,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Price ($countItems Items)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              totalPrice.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping Fee',
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
