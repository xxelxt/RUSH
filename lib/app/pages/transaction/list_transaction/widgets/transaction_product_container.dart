import 'package:cached_network_image/cached_network_image.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

class TransactionProductContainer extends StatelessWidget {
  final Cart item;
  final int countOtherItems;
  final double totalPay;

  const TransactionProductContainer({
    super.key,
    required this.item,
    required this.countOtherItems,
    required this.totalPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hiển thị ảnh sản phẩm
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: item.product!.productImage.first, // Đường dẫn ảnh đầu tiên của sản phẩm
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
                // Hiển thị biểu tượng lỗi khi không tải được ảnh
                return const Icon(Icons.error);
              },
            ),
          ),
          const SizedBox(width: 12),

          // Hiển thị thông tin sản phẩm
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tên sản phẩm
              Text(
                item.product!.productName,
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis, // Ẩn phần dư nếu văn bản quá dài.
              ),

              // Số lượng sản phẩm
              Text(
                '${item.quantity.toNumericFormat()} sản phẩm',
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),

              // Tổng tiền thanh toán
              Text(
                'Tổng tiền: ${totalPay.toCurrency()}',
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),

              // Hiển thị số lượng các sản phẩm khác nếu có
              if (countOtherItems > 0)
                Text(
                  '+${countOtherItems.toNumericFormat()} sản phẩm khác',
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
