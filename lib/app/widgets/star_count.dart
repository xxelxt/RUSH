import 'package:rush/themes/custom_color.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int star;
  final double starSize;
  final void Function(int star)? onTapStar;

  const StarRating({
    super.key,
    required this.star,
    required this.starSize,
    this.onTapStar,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        if (index >= star) {
          return InkWell(
            onTap: onTapStar == null
                ? null
                : () {
                    onTapStar!(index + 1);
                  },
            child: Icon(
              Icons.star_outline_rounded,
              size: starSize,
              color: Colors.blueGrey,
            ),
          );
        } else {
          return InkWell(
            onTap: onTapStar == null
                ? null
                : () {
                    onTapStar!(index + 1);
                  },
            child: Icon(
              Icons.star_rate_rounded,
              size: starSize,
              color: CustomColor.warning,
            ),
          );
        }
      }),
    );
  }
}
