import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/app_font.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/const/app_page_constant.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_model.dart';
import 'package:samsung_sss_flutter/models/page_argument/pdf.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_app_bar.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';
import 'package:samsung_sss_flutter/widgets/file_list_tile.dart';

class ChemicalDetails extends StatefulWidget {
  const ChemicalDetails({
    Key? key,
    required this.chemical,
  }) : super(key: key);

  final ChemicalModel chemical;

  @override
  State<ChemicalDetails> createState() => _ChemicalDetailsState();
}

class _ChemicalDetailsState extends State<ChemicalDetails> {
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_CHEMICAL_DETAIL_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackButton: true),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPageTitle(
                title: Utils.getTranslated(
                  context,
                  AppPageConstants.CHEMICALREGISTER,
                  'leakCheckPageTitle',
                ),
                margin: const EdgeInsets.only(bottom: 33),
              ),
              chemicalSubstanceContainer(context),
              generateSdsListTile(
                widget.chemical.sdsSummary?.fileName,
                widget.chemical.sdsSummary?.url,
              ),
              generatePdfListTile(
                widget.chemical.sds?.fileName,
                widget.chemical.sds?.url,
              ),
              widget.chemical.image?.url != null
                  ? Image.network(widget.chemical.image!.url)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateSdsListTile(String? fileName, String? url) {
    if (fileName != null || url != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FileListTile(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          fileName: fileName!,
          url: url!,
          imagePath: AppImage.sdsSummaryIcon,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.sdsSummary,
              arguments: url,
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget generatePdfListTile(String? pdfName, String? pdfUrl) {
    if (pdfName != null || pdfUrl != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 27),
        child: FileListTile(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          imagePath: AppImage.pdfIcon,
          fileName: pdfName!,
          url: pdfUrl!,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.pdfViewRoute,
              arguments: PdfPropeties(
                url: pdfUrl,
                name: pdfName,
              ),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget chemicalSubstanceContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 34),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          widget.chemical.name,
          style: AppFont.helveticaNeueBold(
            16,
            color: AppColor.wordingColorWhite,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            style: AppFont.helveticaNeueRegular(
              14,
              color: AppColor.wordingColorWhite,
            ),
            children: [
              TextSpan(
                text: Utils.getTranslated(
                      context,
                      AppPageConstants.CHEMICALREGISTER,
                      'symbolTitle',
                    ) +
                    ': ',
              ),
              TextSpan(
                text: widget.chemical.symbol,
                style: AppFont.helveticaNeueMedium(
                  14,
                  color: AppColor.wordingColorWhite,
                ),
              ),
            ],
          ),
        ),
        tileColor: AppColor.palatinateBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
    );
  }
}
