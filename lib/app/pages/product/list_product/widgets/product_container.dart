import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../themes/custom_color.dart';

class ProductContainer extends StatelessWidget {
  final Product item;

  // Hàm callback khi nhấn vào sản phẩm
  final Function() onTap;

  // Constructor
  const ProductContainer({
    super.key,
    required this.item, // Truyền đối tượng sản phẩm
    required this.onTap, // Truyền hàm callback
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(); // Thực hiện hành động khi nhấn vào sản phẩm
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị hình ảnh sản phẩm
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: item.productImage.first, // URL hình ảnh đầu tiên
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, child, loadingProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.progress,
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  // Hiển thị biểu tượng lỗi nếu không tải được ảnh
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tên sản phẩm
          Text(
            item.productName,
            style: Theme.of(context).textTheme.labelLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Cắt chữ nếu quá dài
          ),
          const SizedBox(height: 4),

          // Giá sản phẩm
          Text(
            item.productPrice.toCurrency(), // Chuyển đổi giá thành định dạng tiền tệ
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),

          // Hiển thị đánh giá nếu có
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
                  '${item.rating}' // Số điểm đánh giá
                      ' '
                      '(${item.totalReviews} đánh giá)', // Số lượt đánh giá
                ),
              ],
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
