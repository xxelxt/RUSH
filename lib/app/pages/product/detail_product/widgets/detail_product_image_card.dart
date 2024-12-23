import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'detail_product_image.dart';

class DetailProductImageCard extends StatelessWidget {
  final String imgUrl;
  final int index;

  const DetailProductImageCard({
    super.key,
    required this.imgUrl, // URL hình ảnh
    required this.index, // Chỉ số hình ảnh
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.36,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          // Widget cho phép nhấn vào hình ảnh
          onTap: () {
            // Điều hướng tới màn hình chi tiết hình ảnh khi người dùng nhấn
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DetailProductImage(
                  imgUrl: imgUrl, // Truyền URL hình ảnh
                  index: index, // Truyền chỉ số hình ảnh
                ),
              ),
            );
          },
          child: Hero(
            // Hiệu ứng chuyển đổi giữa các màn hình
            tag: 'detail_image' '$index', // Gắn tag Hero để đồng bộ hiệu ứng
            child: CachedNetworkImage(
              imageUrl: imgUrl, // URL hình ảnh cần hiển thị
              fit: BoxFit.cover, // Hình ảnh được hiển thị vừa khung
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
        ),
      ),
    );
  }
}
