import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/widgets/custom_app_bar.dart';

class PdfView extends StatelessWidget {
  const PdfView({Key? key, required this.pdfUrl, required this.pdfName})
      : super(key: key);
  final String pdfUrl;
  final String pdfName;

  @override
  Widget build(BuildContext context) {
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_PDF_VIEW_SCREEN);

    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        title: pdfName,
        rightButton: IconButton(
          icon: Image.asset(
            AppImage.downloadIcon,
            fit: BoxFit.cover,
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Utils.downloadFile(context, pdfUrl, fileName: pdfName);
          },
        ),
      ),
      body: const PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (progress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
