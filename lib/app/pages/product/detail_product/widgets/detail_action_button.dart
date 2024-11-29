import 'package:flutter/material.dart';

class DetailActionButton extends StatelessWidget {
  final Function() onTapDeleteProduct;
  final Function() onTapEditProduct;
  const DetailActionButton({
    super.key,
    required this.onTapDeleteProduct,
    required this.onTapEditProduct,
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
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                onTapDeleteProduct();
              },
              child: const Text('Delete Product'),
            ),
          ),
          const SizedBox(width: 32.0),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onTapEditProduct();
              },
              child: const Text('Edit Product'),
            ),
          ),
        ],
      ),
    );
  }
}
