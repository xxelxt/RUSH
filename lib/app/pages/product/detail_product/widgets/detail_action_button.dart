import 'package:flutter/material.dart';

class DetailActionButton extends StatelessWidget {
  final Function() onTapDeleteProduct;

  final Function() onTapEditProduct;

  const DetailActionButton({
    super.key,
    required this.onTapDeleteProduct, // Hàm callback để xử lý xoá sản phẩm
    required this.onTapEditProduct, // Hàm callback để xử lý cập nhật sản phẩm
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
          // Nút Xoá sản phẩm
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                onTapDeleteProduct(); // Gọi hàm xử lý khi nhấn nút
              },
              child: const Text('Xoá sản phẩm'),
            ),
          ),
          const SizedBox(width: 32.0),

          // Nút Cập nhật sản phẩm
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onTapEditProduct(); // Gọi hàm xử lý khi nhấn nút
              },
              child: const Text('Cập nhật sản phẩm'),
            ),
          ),
        ],
      ),
    );
  }
}
