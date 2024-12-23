import 'package:rush/app/constants/colors_value.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

// Hiển thị số lượng sản phẩm và nút tăng/giảm trong giỏ hàng
class CountCartQuantity extends StatelessWidget {
  final int quantity;
  final void Function()? onTapAdd; // Hàm callback khi nhấn nút tăng số lượng
  final void Function()? onTapRemove; // Hàm callback khi nhấn nút giảm số lượng

  const CountCartQuantity({
    super.key,
    required this.quantity,
    this.onTapAdd,
    this.onTapRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Nút giảm số lượng
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTapRemove, // Gọi callback khi nhấn
          child: Icon(
            Icons.remove_rounded,
            color: ColorsValue.primaryColor(context),
          ),
        ),
        const SizedBox(width: 12),

        // Hiển thị số lượng sản phẩm
        Text(
          quantity.toNumericFormat(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(width: 12),

        // Nút tăng số lượng
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTapAdd, // Gọi callback khi nhấn
          child: Icon(
            Icons.add_rounded,
            color: ColorsValue.primaryColor(context),
          ),
        ),
      ],
    );
  }
}
