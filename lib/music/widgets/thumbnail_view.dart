import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ThumbnailView extends StatelessWidget {
  const ThumbnailView({
    super.key,
    required this.imageUrl,
    required this.imageBytes,
    required this.isAsset,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final bool isAsset;

  @override
  Widget build(BuildContext context) {
    bool hasPath = imageUrl != null && imageUrl!.isNotEmpty;
    return hasPath
        ? isAsset
            ? Image.asset(
                imageUrl!,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              )
            : Image.file(
                File(imageUrl!),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              )
        : imageBytes != null
            ? Image.memory(
                imageBytes!,
                fit: BoxFit.cover,
              )
            : const SizedBox();
  }
}
