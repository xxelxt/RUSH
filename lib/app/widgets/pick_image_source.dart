import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageSource extends StatefulWidget {
  const PickImageSource({super.key});

  @override
  State<PickImageSource> createState() => _PickImageSourceState();
}

class _PickImageSourceState extends State<PickImageSource> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Lựa chọn hình ảnh từ"),
      content: const Text("Lựa chọn hình ảnh từ camera hoặc thư viện ảnh"),
      actions: [
        // Nút lựa chọn Camera
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(ImageSource.camera);
          },
          child: const Text(
            "Camera",
            textAlign: TextAlign.start,
          ),
        ),

        // Nút lựa chọn Thư viện ảnh
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(ImageSource.gallery);
          },
          child: const Text("Thư viện ảnh"),
        ),
      ],
    );
  }
}
