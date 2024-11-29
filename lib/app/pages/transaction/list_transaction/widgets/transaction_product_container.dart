import 'package:cached_network_image/cached_network_image.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

class TransactionProductContainer extends StatelessWidget {
  final Cart item;
  final int countOtherItems;
  final double totalPay;
  const TransactionProductContainer({super.key, required this.item, required this.countOtherItems, required this.totalPay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: item.product!.productImage.first,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (_, child, loadingProgress) {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.progress,
                  ),
                );
              },
              errorWidget: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.product!.productName,
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${item.quantity.toNumericFormat()} Items',
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Total : ${totalPay.toCurrency()}',
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
              if (countOtherItems > 0)
                Text(
                  '+${countOtherItems.toNumericFormat()} Other Items',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
