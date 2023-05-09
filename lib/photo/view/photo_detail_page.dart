import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetailPage extends StatelessWidget {
  const PhotoDetailPage({
    super.key,
    required this.file,
  });

  final File file;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: FileImage(file),
              initialScale: PhotoViewComputedScale.contained,
              basePosition: Alignment.center,
              maxScale: PhotoViewComputedScale.contained * 2,
              minScale: PhotoViewComputedScale.contained,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}