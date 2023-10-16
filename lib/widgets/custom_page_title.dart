import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/app_font.dart';

class CustomPageTitle extends StatelessWidget {
  const CustomPageTitle({Key? key, required this.title, this.margin})
      : super(key: key);
  final String title;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        title,
        style: AppFont.helveticaNeueBold(
          30,
          color: AppColor.samsungBlue,
        ),
      ),
    );
  }
}
