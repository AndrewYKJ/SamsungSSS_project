import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/app_font.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.imagePath,
    required this.title,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.fontSize = 16,
    this.isNetworkImage,
    this.margin,
    this.padding,
  }) : super(key: key);

  final String? imagePath;
  final String title;
  final Color? backgroundColor;
  final Color? borderColor;
  final void Function()? onTap;
  final double fontSize;
  final bool? isNetworkImage;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor ?? AppColor.borderLightGrey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildImage(imagePath, isNetworkImage ?? false),
            Expanded(
              child: Text(
                title,
                style: AppFont.helveticaNeueBold(
                  fontSize,
                  color: AppColor.wordingColorBlack,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imagePath, bool isNetworkImage) {
    if (imagePath == null) return const SizedBox.shrink();

    if (isNetworkImage) {
      return Container(
        margin: const EdgeInsets.only(right: 24),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
