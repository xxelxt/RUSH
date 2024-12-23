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
          'Thông tin khách hàng',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),

        // Hiển thị tên người nhận
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tên người nhận',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              customer.fullName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),

        // Hiển thị địa chỉ email
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Địa chỉ email',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              customer.emailAddress,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),

        // Hiển thị số điện thoại
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Số điện thoại',
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
