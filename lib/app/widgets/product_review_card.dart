import 'package:rush/app/widgets/star_count.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/domain/entities/review/review.dart';

// Hiển thị thông tin đánh giá sản phẩm
class ProductReviewCard extends StatelessWidget {
  final Review item;

  ProductReviewCard({super.key, required this.item}) {
    configureTimeago();
  }

  void configureTimeago() {
    timeago.setLocaleMessages('vi', timeago.ViMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hiển thị tên người đánh giá
            Text(
              item.reviewerName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            // Hiển thị thời gian đánh giá dưới dạng timeago
            Text(
              timeago.format(item.createdAt, locale: 'vi'),
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
        const SizedBox(height: 4),

        // Hiển thị đánh giá sao
        StarRating(
          star: item.star,
          starSize: 16,
        ),
        const SizedBox(height: 8),

        // Hiển thị mô tả đánh giá
        Text(
          item.description ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
