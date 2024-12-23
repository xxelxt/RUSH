import 'package:rush/core/domain/entities/address/address.dart';
import 'package:flutter/material.dart';

class SelectedShippingAddress extends StatelessWidget {
  final Address shippingAddress;
  const SelectedShippingAddress({
    super.key,
    required this.shippingAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Địa chỉ giao hàng',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        ListTile(
          dense: true,
          title: Text(shippingAddress.name),
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(vertical: -4),
          subtitle: Text(
            '${shippingAddress.address} ${shippingAddress.city} ${shippingAddress.zipCode}',
          ),
        ),
      ],
    );
  }
}
