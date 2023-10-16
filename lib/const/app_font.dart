import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFont {
  static TextStyle helveticaNeueRegular(double size,
      {Color? color, TextDecoration? decoration, TextOverflow? overflow}) {
    return TextStyle(
      fontFamily: 'HelveticaNeue',
      fontSize: size.sp,
      fontWeight: FontWeight.normal,
      color: color,
      decoration: decoration,
      overflow: overflow,
    );
  }

  static TextStyle helveticaNeueBold(double size,
      {Color? color, TextDecoration? decoration, TextOverflow? overflow}) {
    return TextStyle(
      fontFamily: 'HelveticaNeue',
      fontSize: size.sp,
      fontWeight: FontWeight.bold,
      color: color,
      decoration: decoration,
    );
  }

  static TextStyle helveticaNeueMedium(double size,
      {Color? color, TextDecoration? decoration, TextOverflow? overflow}) {
    return TextStyle(
      fontFamily: 'HelveticaNeue',
      fontSize: size.sp,
      fontWeight: FontWeight.w500,
      color: color,
      decoration: decoration,
      overflow: overflow,
    );
  }

  static TextStyle poppinsThin(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: FontWeight.w100,
      color: color,
      decoration: decoration,
    );
  }

  static TextStyle poppinsLight(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: FontWeight.w300,
        color: color,
        decoration: decoration);
  }

  static TextStyle poppinsRegular(double size,
      {Color? color, TextDecoration? decoration, double? height}) {
    return TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: FontWeight.w400,
        height: height,
        color: color,
        decoration: decoration);
  }

  static TextStyle poppinsMedium(double size,
      {Color? color, TextDecoration? decoration, TextOverflow? overflow}) {
    return TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color,
        decoration: decoration,
        overflow: overflow);
  }

  static TextStyle poppinsSemibold(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        decoration: decoration);
  }

  static TextStyle poppinsBold(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        decoration: decoration);
  }
}
