import 'package:cached_network_image/cached_network_image.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

import '../../../../routes.dart';

class CheckoutProductContainer extends StatelessWidget {
  final Cart item; // Đối tượng sản phẩm trong giỏ hàng
  const CheckoutProductContainer({super.key, required this.item}); // Constructor nhận thông tin sản phẩm

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        // Chuyển đến trang chi tiết sản phẩm
        NavigateRoute.toDetailProduct(context: context, productId: item.productId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  // Hiển thị vòng tròn tải trong khi hình ảnh đang tải
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.progress, // Tiến trình tải
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  // Hiển thị icon lỗi nếu hình ảnh không tải được
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
                  // Tên sản phẩm
                  Text(
                    item.product!.productName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),

                  // Giá sản phẩm
                  Text(
                    item.product!.productPrice.toCurrency(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  // Số lượng sản phẩm
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
