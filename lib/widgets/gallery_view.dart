import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';

class GalleryPhotoView extends StatelessWidget {
  GalleryPhotoView({
    super.key,
    this.initialIndex = 0,
    required this.images,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final int initialIndex;
  final PageController pageController;
  final List<BlobFileModel> images;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_GALLERY_VIEW_SCREEN);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(AppImage.closeButton, color: AppColor.lightBlue),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: images.length,
              loadingBuilder: (context, progress) {
                if (progress != null && progress.expectedTotalBytes != null) {
                  return Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!,
                      ),
                    ),
                  );
                }

                return const Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              pageController: pageController,
              scrollDirection: scrollDirection,
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final item = images[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.url),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}
