import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'detail_product_image.dart';

class DetailProductImageCard extends StatelessWidget {
  final String imgUrl;
  final int index;
  const DetailProductImageCard({super.key, required this.imgUrl, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.36,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DetailProductImage(
                  imgUrl: imgUrl,
                  index: index,
                ),
              ),
            );
          },
          child: Hero(
            tag: 'detail_image' '$index',
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              fit: BoxFit.cover,
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
