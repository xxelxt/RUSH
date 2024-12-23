import 'package:cached_network_image/cached_network_image.dart';
import 'package:rush/app/widgets/cart/count_cart_quantity.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

import '../../../routes.dart';

// Hiển thị chi tiết sản phẩm trong giỏ hàng
class CartContainer extends StatelessWidget {
  final Cart item; // Thông tin sản phẩm trong giỏ hàng
  final Function() onTapAdd; // Hàm callback khi tăng số lượng sản phẩm
  final Function() onTapRemove; // Hàm callback khi giảm số lượng sản phẩm

  const CartContainer({
    super.key,
    required this.item,
    required this.onTapAdd,
    required this.onTapRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        // Chuyển đến màn hình chi tiết sản phẩm
        NavigateRoute.toDetailProduct(context: context, productId: item.productId);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 90,
        width: double.infinity,
        child: Row(
          children: [
            // Hình ảnh sản phẩm
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

            // Thông tin sản phẩm
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Expanded(
                    child: Text(
                      item.product!.productName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  // Giá sản phẩm và số lượng
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Giá sản phẩm
                        Text(
                          item.product!.productPrice.toCurrency(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),

                        // Điều khiển số lượng sản phẩm
                        CountCartQuantity(
                          onTapAdd: onTapAdd, // Callback khi tăng số lượng
                          onTapRemove: onTapRemove, // Callback khi giảm số lượng
                          quantity: item.quantity, // Số lượng hiện tại
                        ),
                      ],
                    ),
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
