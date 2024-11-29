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
      title: const Text("Pick Image From"),
      content: const Text("Pictures can be taken directly from the camera or gallery"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(ImageSource.camera);
          },
          child: const Text(
            "Camera",
            textAlign: TextAlign.start,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(ImageSource.gallery);
          },
          child: const Text("Gallery"),
        ),
      ],
    );
  }
}
