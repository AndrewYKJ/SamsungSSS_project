import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';

class GalleryArguments {
  final int initialIndex;
  final List<BlobFileModel> images;
  final Axis scrollDirection;

  GalleryArguments({
    this.initialIndex = 0,
    required this.images,
    this.scrollDirection = Axis.horizontal,
  });
}
