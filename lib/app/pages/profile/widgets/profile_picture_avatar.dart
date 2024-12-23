import 'package:rush/app/constants/colors_value.dart'; // Sử dụng tệp màu tuỳ chỉnh
import 'package:flutter/material.dart';

// Widget hiển thị hình đại diện có thể cập nhật
class ProfilePictureAvatar extends StatelessWidget {
  final String photoProfileUrl;

  final Function() onTapCamera;

  final bool isLoading;

  // Constructor
  const ProfilePictureAvatar({
    super.key,
    required this.photoProfileUrl, // Truyền URL ảnh đại diện
    required this.onTapCamera, // Truyền hàm xử lý sự kiện camera
    this.isLoading = false, // Mặc định không đang tải
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Stack(
        children: [
          // Hình đại diện
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              backgroundImage: photoProfileUrl.isNotEmpty
                  ? NetworkImage(photoProfileUrl) // Nếu có URL thì hiển thị ảnh
                  : null, // Nếu không có URL thì không hiển thị ảnh
              child: photoProfileUrl.isEmpty
                  ? const Icon(
                Icons.person, // Hiển thị biểu tượng người nếu không có URL ảnh
                size: 80,
              )
                  : null,
            ),
          ),

          // Biểu tượng camera để cập nhật ảnh
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: ShapeDecoration(
                color: ColorsValue.primaryColor(context),
                shape: const CircleBorder(),
              ),
              padding: isLoading ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
              child: isLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(), // Hiển thị vòng xoay khi đang tải
              )
                  : IconButton(
                onPressed: () {
                  onTapCamera(); // Gọi hàm xử lý sự kiện camera khi nhấn
                },
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
