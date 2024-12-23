import 'package:rush/app/constants/colors_value.dart';
import 'package:flutter/material.dart';

class UserActionButton extends StatelessWidget {
  final Function() onTapFavorite;

  final void Function()? onTapAddToCart;

  final bool isWishlisted;

  const UserActionButton({
    super.key,
    required this.onTapFavorite, // Hàm xử lý khi nhấn nút yêu thích
    required this.onTapAddToCart, // Hàm xử lý khi nhấn nút thêm vào giỏ hàng
    this.isWishlisted = false, // Mặc định sản phẩm chưa được yêu thích
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Row(
        children: [
          // Nút yêu thích
          IconButton(
            onPressed: () {
              onTapFavorite(); // Gọi hàm xử lý khi nhấn nút
            },
            icon: isWishlisted
                ? const Icon(Icons.favorite_rounded)
                : const Icon(Icons.favorite_border_rounded),
            color: ColorsValue.primaryColor(context),
            style: IconButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              disabledBackgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              hoverColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.08),
              focusColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.12),
              highlightColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.12),
            ),
          ),
          const SizedBox(width: 20.0),

          // Nút Thêm vào giỏ hàng
          Expanded(
            child: ElevatedButton(
              onPressed: onTapAddToCart,
              child: onTapAddToCart == null
                  ? const Text('Hết hàng')
                  : const Text('Thêm vào giỏ hàng'),
            ),
          ),
        ],
      ),
    );
  }
}
