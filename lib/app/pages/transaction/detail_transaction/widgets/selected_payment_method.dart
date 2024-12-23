import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:flutter/material.dart';

class SelectedPaymentMethod extends StatelessWidget {
  final PaymentMethod paymentMethod;

  const SelectedPaymentMethod({
    super.key,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phương thức thanh toán',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        ListTile(
          dense: true,
          title: Text(paymentMethod.cardholderName),
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(vertical: -4),
          subtitle: Text(
            paymentMethod.cardNumber,
          ),
        ),
      ],
    );
  }
}
