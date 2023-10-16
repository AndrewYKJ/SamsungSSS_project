import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_list_tile.dart';

class SdsSummaryListTile extends StatelessWidget {
  const SdsSummaryListTile({
    Key? key,
    required this.fileName,
    required this.url,
  }) : super(key: key);
  final String fileName;
  final String url;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      title: fileName,
      imagePath: AppImage.sdsSummaryIcon,
      backgroundColor: AppColor.lightBlue,
      borderColor: AppColor.borderLightBlue,
      fontSize: 12,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.sdsSummary,
          arguments: url,
        );
      },
    );
  }
}
