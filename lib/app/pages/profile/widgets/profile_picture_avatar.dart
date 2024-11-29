import 'package:rush/app/constants/colors_value.dart';
import 'package:flutter/material.dart';

class ProfilePictureAvatar extends StatelessWidget {
  final String photoProfileUrl;
  final Function() onTapCamera;
  final bool isLoading;
  const ProfilePictureAvatar({
    super.key,
    required this.photoProfileUrl,
    required this.onTapCamera,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              backgroundImage: photoProfileUrl.isNotEmpty ? NetworkImage(photoProfileUrl) : null,
              child: photoProfileUrl.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 80,
                    )
                  : null,
            ),
          ),

          // Camera
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
                      child: CircularProgressIndicator(),
                    )
                  : IconButton(
                      onPressed: () {
                        onTapCamera();
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
