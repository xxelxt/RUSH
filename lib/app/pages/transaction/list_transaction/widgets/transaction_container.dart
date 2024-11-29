import 'package:rush/app/pages/transaction/list_transaction/widgets/transaction_product_container.dart';
import 'package:rush/app/pages/transaction/list_transaction/widgets/transaction_status_chip.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionContainer extends StatelessWidget {
  final Transaction item;
  const TransactionContainer({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigateRoute.toDetailTransaction(context: context, transactionID: item.transactionId);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item.account?.fullName ?? '',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: item.account != null ? ' - ' : '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: DateFormat('dd MMM yyyy').format(item.createdAt!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TransactionStatusChip(status: item.transactionStatus!),
            ],
          ),
          TransactionProductContainer(
            item: item.purchasedProduct.first,
            countOtherItems: item.purchasedProduct.length - 1,
            totalPay: item.totalPay!,
          ),
        ],
      ),
    );
  }
}
