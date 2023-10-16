import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';

import '../const/app_font.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool? obsure;
  final bool? active;
  final String? prefix;
  final Widget? suffix;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.obsure,
    this.active,
    this.prefix,
    this.suffix,
    this.validator,
    this.readOnly,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      obscureText: obsure ?? false,
      readOnly: readOnly ?? false,
      onTap: onTap,
      decoration: InputDecoration(
        enabled: active ?? true,
        prefixIconConstraints: prefix != null ? const BoxConstraints() : null,
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                child: Text(
                  prefix!,
                  style: AppFont.helveticaNeueRegular(16,
                      color: AppColor.wordingColorGrey),
                ),
              )
            : null,
        suffixIconConstraints: suffix != null ? const BoxConstraints() : null,
        suffixIcon: suffix != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 8, 0), child: suffix)
            : null,
        hintText: hintText ?? '',
        hintStyle:
            AppFont.helveticaNeueRegular(16, color: AppColor.wordingColorGrey),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: AppColor.samsungBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: AppColor.samsungBlue),
        ),
        contentPadding: const EdgeInsets.all(12),
        isCollapsed: true,
      ),
    );
  }
}
