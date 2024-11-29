import 'dart:io';

import 'package:flutter/material.dart';

class ImageFilePreview extends StatelessWidget {
  final File imageFile;
  final Function() onTap;
  const ImageFilePreview({super.key, required this.imageFile, required this.onTap});

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
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                width: 64,
                height: 64,
              ),
            ),
          ),
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
