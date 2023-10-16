import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/app_font.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.showBackButton = false,
    this.rightButton,
  }) : super(key: key);

  final String? title;
  final bool showBackButton;
  final Widget? rightButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: title != null
          ? Text(
              title!,
              style: AppFont.helveticaNeueBold(
                14,
                color: AppColor.wordingColorBlack,
              ),
            )
          : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: Image.asset(AppImage.backButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      actions: rightButton != null ? [rightButton!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
