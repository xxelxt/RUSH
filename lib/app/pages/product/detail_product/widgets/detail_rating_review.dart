import 'package:rush/themes/custom_color.dart';
import 'package:flutter/material.dart';

class DetailRatingReview extends StatelessWidget {
  final double rating;
  final int totalReview;
  final Function() onTapSeeAll; // Hàm callback khi người dùng nhấn Xem tất cả đánh giá

  const DetailRatingReview({
    super.key,
    required this.rating, // Điểm đánh giá
    required this.totalReview, // Tổng số lượt đánh giá
    required this.onTapSeeAll, // Hàm callback khi nhấn
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.star_rounded,
              size: 24,
              color: CustomColor.warning,
            ),
            const SizedBox(width: 8),
            Text(
              '$rating ($totalReview đánh giá)',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // Text Xem tất cả đánh giá
        InkWell(
          onTap: () {
            onTapSeeAll(); // Gọi hàm callback khi người dùng nhấn
          },
          child: Text(
            'Xem tất cả đánh giá',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
