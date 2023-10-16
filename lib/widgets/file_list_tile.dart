import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/widgets/custom_list_tile.dart';

class FileListTile extends StatelessWidget {
  const FileListTile({
    Key? key,
    required this.fileName,
    required this.url,
    required this.imagePath,
    this.padding,
    this.onTap,
  }) : super(key: key);
  final String fileName;
  final String url;
  final String imagePath;
  final EdgeInsets? padding;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      padding: padding,
      title: fileName,
      imagePath: imagePath,
      backgroundColor: AppColor.lightBlue,
      borderColor: AppColor.borderLightBlue,
      fontSize: 14,
      onTap: onTap,
    );
  }
}
