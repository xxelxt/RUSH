import 'package:cached_network_image/cached_network_image.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/routes.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

class DetailTransactionProduct extends StatelessWidget {
  final Cart item;

  const DetailTransactionProduct({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        // Chuyển đến trang chi tiết sản phẩm khi nhấn
        NavigateRoute.toDetailProduct(context: context, productId: item.productId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        height: 90,
        width: double.infinity,
        child: Row(
          children: [
            // Hiển thị hình ảnh sản phẩm.
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

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị tên sản phẩm.
                  Text(
                    item.product!.productName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),

                  // Hiển thị giá sản phẩm.
                  Text(
                    item.product!.productPrice.toCurrency(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  // Hiển thị số lượng sản phẩm.
                  Text(
                    'Số lượng: ${item.quantity.toNumericFormat()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
