import 'package:flutter/material.dart';

class ImageProductPreview extends StatelessWidget {
  final Widget image;

  final Function() onTap;

  const ImageProductPreview({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: 86,
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image,
            ),
          ),

          // Nút xóa ở góc trên bên phải
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              child: const Icon(Icons.remove_circle_rounded),
              onTap: () {
                onTap();
              },
            ),
          ),
        ],
      ),
    );
  }
}
