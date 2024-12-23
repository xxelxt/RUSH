import 'dart:io';

import 'package:flutter/material.dart';

class ImageFilePreview extends StatelessWidget {
  final File imageFile;
  final Function() onTap; // Hàm callback để xử lý sự kiện xóa ảnh

  const ImageFilePreview({
    super.key,
    required this.imageFile, // Truyền file hình ảnh khi khởi tạo
    required this.onTap, // Truyền hàm callback khi khởi tạo
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: 86,
      child: Stack(
        children: [
          // Hiển thị hình ảnh
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                width: 64,
                height: 64,
              ),
            ),
          ),

          // Biểu tượng xóa ảnh ở góc phải trên
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              child: const Icon(Icons.remove_circle_rounded),
              onTap: () {
                onTap(); // Gọi hàm callback khi nhấn vào biểu tượng
              },
            ),
          ),
        ],
      ),
    );
  }
}
