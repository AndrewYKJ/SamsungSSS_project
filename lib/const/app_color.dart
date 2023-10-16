import 'package:flutter/material.dart';
import 'utils.dart';

class AppColor {
  static final Color samsungBlue = HexColor('#1428A0');
  static final Color samsungBlack = HexColor('#121212');
  static final Color wordingColorBlack = HexColor('#222222');
  static final Color wordingColorGrey = HexColor('#A7A7A7');
  static final Color wordingColorWhite = HexColor('#FFFFFF');
  static final Color samsungTeal = HexColor('#D6F2FF');

  static const Color choiceChipColor = Color(0xffA2E6FF);
  static const Color choiceChipBorderColor = Color(0xff23A0CE);
  static const Color borderLightGrey = Color(0xffE5E5E5);
  static const Color palatinateBlue = Color(0xff273AF5);
  static const Color lightBlue = Color(0xfff3fdff);
  static const Color borderLightBlue = Color(0xFFA3E6FF);

  static final Color greenDot = HexColor("#75fcb3");
  static final Color redDot = HexColor("#FF0000");
  static final Color borderGrey = HexColor("#D9D9D9");
  static final Color greenBorder = HexColor("#81ed95");
  static final Color redBorder = HexColor("#ec6545");

  static final Color activeGreen = HexColor("#00FF63");
  static final Color inactiveRed = HexColor("ea3323");
  static final Color noneGrey = HexColor("dddddd");

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
