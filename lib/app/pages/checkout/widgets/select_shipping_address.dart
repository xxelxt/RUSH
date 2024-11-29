import 'package:rush/core/domain/entities/address/address.dart';
import 'package:flutter/material.dart';

import '../../../../themes/custom_color.dart';
import '../../../constants/colors_value.dart';

class SelectShippingAddress extends StatelessWidget {
  final Address? shippingAddress;
  final Function() selectAddress;
  final Function() removeAddress;
  const SelectShippingAddress({
    super.key,
    this.shippingAddress,
    required this.selectAddress,
    required this.removeAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping Address',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (shippingAddress != null)
              TextButton(
                onPressed: () {
                  selectAddress();
                },
                child: const Text('Other Address'),
              ),
          ],
        ),
        if (shippingAddress == null)
          TextButton.icon(
            onPressed: () {
              selectAddress();
            },
            icon: Icon(
              Icons.add_rounded,
              color: ColorsValue.primaryColor(context),
            ),
            label: const Text('Add Address'),
          ),
        if (shippingAddress != null)
          ListTile(
            dense: true,
            title: Text(shippingAddress!.name),
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(vertical: -4),
            subtitle: Text(
              '${shippingAddress!.address} ${shippingAddress!.city} ${shippingAddress!.zipCode}',
            ),
            trailing: IconButton(
              onPressed: () {
                removeAddress();
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
