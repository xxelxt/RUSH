import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerContainer extends StatelessWidget {
  final Account customer;
  const CustomerContainer({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.transparent,
            backgroundImage: customer.photoProfileUrl.isNotEmpty ? NetworkImage(customer.photoProfileUrl) : null,
            child: customer.photoProfileUrl.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 32,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  customer.fullName,
                  style: Theme.of(context).textTheme.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  customer.emailAddress,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  customer.phoneNumber.formatPhoneNumber(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    customer.banStatus
                        ? OutlinedButton(
                            onPressed: () {
                              context.read<AccountProvider>().ban(accountId: customer.accountId, ban: false);
                            },
                            child: const Text('Mở khoá tài khoản'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              context.read<AccountProvider>().ban(accountId: customer.accountId, ban: true);
                            },
                            child: const Text('Khoá tài khoản'),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
