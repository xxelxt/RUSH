import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

class CustomerInformation extends StatelessWidget {
  final Account customer;
  const CustomerInformation({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Information',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Name',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              customer.fullName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Email',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              customer.emailAddress,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phone Number',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              customer.phoneNumber.separateCountryCode(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ],
    );
  }
}
