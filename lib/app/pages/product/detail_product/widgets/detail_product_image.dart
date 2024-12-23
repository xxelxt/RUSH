import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailProductImage extends StatelessWidget {
  final String imgUrl;

  final int index;

  const DetailProductImage({
    super.key,
    required this.imgUrl, // URL hình ảnh
    required this.index, // Chỉ số hình ảnh
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
      body: SafeArea(
        // Giữ nội dung trong vùng hiển thị an toàn
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Hero(
                // Hiệu ứng chuyển đổi giữa các màn hình
                tag: 'detail_image' '$index', // Gắn tag Hero dựa trên chỉ số hình ảnh
                child: InteractiveViewer(
                  // Cho phép phóng to, thu nhỏ và kéo hình ảnh
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
          ),
        ),
      ),
    );
  }
}
