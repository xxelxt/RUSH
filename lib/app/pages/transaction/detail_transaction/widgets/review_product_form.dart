import 'package:cached_network_image/cached_network_image.dart';
import 'package:rush/app/widgets/star_count.dart';
import 'package:rush/core/domain/entities/review/review.dart';
import 'package:flutter/material.dart';

class ReviewProductForm extends StatelessWidget {
  final Review data;
  final void Function(int star) onTapStar; // Hàm callback khi chọn số sao

  const ReviewProductForm({
    super.key,
    required this.data, // Đối tượng đánh giá
    required this.onTapStar, // Callback cho sự kiện chọn số sao
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề đánh giá
          Text(
            'Đánh giá sản phẩm',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Hiển thị thông tin sản phẩm và sao đánh giá
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hình ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: data.product.productImage.first,
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

              // Hiển thị tên sản phẩm và số sao
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tên sản phẩm
                  Text(
                    data.product.productName,
                    style: Theme.of(context).textTheme.labelLarge,
                    overflow: TextOverflow.ellipsis, // Cắt đoạn nếu tên quá dài
                  ),
                  const SizedBox(height: 8),

                  // Widget hiển thị và chọn số sao
                  StarRating(
                    star: data.star, // Số sao hiện tại
                    starSize: 24,
                    onTapStar: onTapStar, // Hàm callback khi chọn số sao
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Trường nhập nhận xét
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Hãy nói cho chúng tôi biết cảm nghĩ của bạn về sản phẩm này?',
              labelText: 'Nhận xét',
            ),
            onChanged: (value) {
              data.description = value; // Cập nhật nhận xét trong đối tượng đánh giá
            },
          ),
        ],
      ),
    );
  }
}
