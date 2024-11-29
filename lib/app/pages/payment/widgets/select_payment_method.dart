import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:flutter/material.dart';

import '../../../../themes/custom_color.dart';
import '../../../constants/colors_value.dart';

class SelectPaymentMethod extends StatelessWidget {
  final PaymentMethod? paymentMethod;
  final Function() selectPaymentMethod;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (paymentMethod != null)
              TextButton(
                onPressed: () {
                  selectPaymentMethod();
                },
                child: const Text('Other Method'),
              ),
          ],
        ),
        if (paymentMethod == null)
          TextButton.icon(
            onPressed: () {
              selectPaymentMethod();
            },
            icon: Icon(
              Icons.add_rounded,
              color: ColorsValue.primaryColor(context),
            ),
            label: const Text('Add Payment Method'),
          ),
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
                removePaymentMethod();
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
