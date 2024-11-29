import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../themes/custom_color.dart';

class ProductContainer extends StatelessWidget {
  final Product item;
  final Function() onTap;
  const ProductContainer({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: item.productImage.first,
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
          ),
          const SizedBox(height: 12),
          Text(
            item.productName,
            style: Theme.of(context).textTheme.labelLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            item.productPrice.toCurrency(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          if (item.rating != 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: CustomColor.warning,
                ),
                const SizedBox(width: 8),
                Text(
                  '${item.rating}' ' ' '(${item.totalReviews} Reviews)',
                ),
              ],
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
