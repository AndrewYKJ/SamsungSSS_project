import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';
import 'package:samsung_sss_flutter/models/page_argument/gallery_argument.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';

class GalleryImage extends StatelessWidget {
  const GalleryImage({
    super.key,
    required this.images,
    required this.index,
  });

  final List<BlobFileModel> images;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.galleryViewRoute,
        arguments: GalleryArguments(
          images: images,
          initialIndex: index,
        ),
      ),
      child: Image.network(
        images[index].url,
        fit: BoxFit.cover,
      ),
    );
  }
}
