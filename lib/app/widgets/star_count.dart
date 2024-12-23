import 'package:rush/themes/custom_color.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int star;
  final double starSize;
  final void Function(int star)? onTapStar; // Hàm callback khi người dùng chọn một ngôi sao

  const StarRating({
    super.key,
    required this.star,
    required this.starSize,
    this.onTapStar, // Hàm callback tùy chọn
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // Tạo một hàng chứa các biểu tượng sao
      children: List.generate(5, (index) {
        if (index >= star) {
          // Nếu index lớn hơn hoặc bằng số sao đánh giá
          return InkWell(
            onTap: onTapStar == null
                ? null
                : () {
              onTapStar!(index + 1); // Gọi hàm callback với giá trị sao được chọn
            },
            child: Icon(
              Icons.star_outline_rounded, // Biểu tượng sao rỗng
              size: starSize,
              color: Colors.blueGrey, // Màu của sao chưa được đánh giá
            ),
          );
        } else {
          // Nếu index nhỏ hơn số sao đánh giá
          return InkWell(
            onTap: onTapStar == null
                ? null
                : () {
              onTapStar!(index + 1); // Gọi hàm callback với giá trị sao được chọn
            },
            child: Icon(
              Icons.star_rate_rounded, // Biểu tượng sao đầy
              size: starSize,
              color: CustomColor.warning, // Màu của sao đã được đánh giá
            ),
          );
        }
      }),
    );
  }
}
