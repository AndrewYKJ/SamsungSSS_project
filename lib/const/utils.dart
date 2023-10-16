// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:samsung_sss_flutter/cache/app_cache.dart';
import 'package:samsung_sss_flutter/const/app_page_constant.dart';
import 'package:samsung_sss_flutter/const/firebase_analytics.dart';
import 'package:samsung_sss_flutter/const/localization.dart';
import 'package:samsung_sss_flutter/models/json/error/error_model.dart';

import 'constants.dart';

class Utils {
  static void unfocusContext(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static String getTranslated(
      BuildContext context, String pageKey, String textKey) {
    return MyLocalization.of(context).translate(pageKey, textKey);
  }

  static Future<Size> getImageSize(String s) async {
    final Completer<Size> completer = Completer<Size>();
    final ImageStream imageStream = Image.network(
      s,
    ).image.resolve(ImageConfiguration.empty);
    imageStream.addListener(
      ImageStreamListener(
        (ImageInfo imageInfo, bool synchronousCall) {
          final Size imageSize = Size(
            imageInfo.image.width.toDouble(),
            imageInfo.image.height.toDouble(),
          );
          completer.complete(imageSize);
        },
      ),
    );
    return completer.future;
  }

  static printInfo(Object object) {
    if (Constants.IS_DEBUG) {
      print(object);
    }
  }

  static void showAlertDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void handleError(
    BuildContext context,
    dynamic error,
  ) {
    // Default Error title and message
    String title = Utils.getTranslated(
      context,
      AppPageConstants.UTILITY,
      'alert_dialog_title_error_text',
    );
    String message = Utils.getTranslated(
      context,
      AppPageConstants.UTILITY,
      'general_alert_message_error_response',
    );

    // Override error title and message if true
    if (error is DioException) {
      if (error.response != null) {
        if (error.response?.data != null) {
          ErrorModel dioError = ErrorModel.fromJson(error.response!.data);
          // (title: title, message: message) = getResponseErrorTitleMessage(context, dioError);
          message = dioError.message;
        }
      }
    }

    showAlertDialog(context, title, message);

    Utils.printInfo('ERROR: $error');
  }

  // static ({String title, String message}) getResponseErrorTitleMessage(
  //   BuildContext context,
  //   ErrorModel error,
  // ) {
  //   String title = Utils.getTranslated(
  //       context, AppPageConstants.UTILITY, 'alert_dialog_title_error_text');
  //   String message = Utils.getTranslated(context, AppPageConstants.UTILITY,
  //       'general_alert_message_error_response');

  //   switch (error.code) {
  //     case "NOT_FOUND":
  //       message = Utils.getTranslated(
  //         context,
  //         AppPageConstants.UTILITY,
  //         'item_not_found',
  //       );
  //       break;
  //     case "INVALID_REQUEST":
  //       message = Utils.getTranslated(
  //         context,
  //         AppPageConstants.UTILITY,
  //         'invalid_request',
  //       );
  //       break;
  //   }

  //   return (title: title, message: message);
  // }

  static setFirebaseAnalyticsCurrentScreen(String screen) {
    AnalyticsFirebase.setFirebaseAnalyticsCurrentScreen(screen);
  }

  static TValue customSwitch<TOptionType, TValue>(
      TOptionType selectedOption, Map<TOptionType, TValue> branches,
      [TValue? defaultValue]) {
    if (!branches.containsKey(selectedOption)) {
      return defaultValue!;
    }

    return branches[selectedOption]!;
  }

  static String getImagePath(String imageName) {
    return Constants.ASSET_IMAGES + imageName;
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    bool isGranted = status.isGranted;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      isGranted = result.isGranted;
    }
    return isGranted;
  }

  static Future<void> downloadFile(BuildContext context, String url,
      {String? fileName}) async {
    await requestNotificationPermission();
    final path = (await getApplicationDocumentsDirectory()).path;
    final token = await AppCache.getStringValue(AppCache.ACCESS_TOKEN_PREF);
    final header = {HttpHeaders.authorizationHeader: 'Bearer ' + token};

    Fluttertoast.showToast(
      msg: getTranslated(
        context,
        AppPageConstants.UTILITY,
        'download_started',
      ),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    await FlutterDownloader.enqueue(
      url: url,
      headers: header,
      fileName: fileName,
      savedDir: path,
      saveInPublicStorage: true,
      // show download progress in status bar (for Android)
      showNotification: true,
      // click on the notification to open the downloaded file (for Android)
      openFileFromNotification: true,
    );
  }

  static String formatPhoneNumber(String phoneNo) {
    final formatedNumber =
        '+${phoneNo.substring(0, 2)} ${phoneNo.substring(2, 4)} ${phoneNo.substring(4, 7)} ${phoneNo.substring(7)}';
    return formatedNumber;
  }

  static final displayDateFormat = DateFormat('dd MMMM yyyy');
  static String getServerFormatDob(String dob) {
    final date = displayDateFormat.parse(dob);
    final serverDateFormat = DateFormat('yyyy-MM-dd');
    dob = serverDateFormat.format(date);
    return dob;
  }

  static String? requiredValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'requiredFieldErrorText',
      );
    }
    return null;
  }

  static String? phoneValidator(BuildContext context, String? value) {
    // check regex pattern
    if (Constants.phoneNumberRegex.hasMatch(value ?? '')) {
      return null;
    } else {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'invalidPhoneNoErrorText',
      );
    }
  }

  static String? emailValidator(BuildContext context, String? value) {
    final requiredMessage = requiredValidator(context, value);
    if (requiredMessage != null) {
      return requiredMessage;
    }

    if (Constants.emailRegex.hasMatch(value ?? '')) {
      return null;
    } else {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'invalidEmailErrorText',
      );
    }
  }

  static String? passwordValidator(BuildContext context, String? password) {
    final requiredMessage = requiredValidator(context, password);
    if (requiredMessage != null) {
      return requiredMessage;
    }

    if (password!.length < 8) {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'passwordLengthErrorText',
      );
    }

    // Check if the password contains at least one uppercase character
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'passwordUppercaseErrorText',
      );
    }

    // Check if the password contains at least one lowercase character
    if (!password.contains(RegExp(r'[a-z]'))) {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'passwordDigitErrorText',
      );
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'passwordDigitErrorText',
      );
    }

    // Check if the password contains at least one special character
    if (!password.contains(Constants.specialCharacterRegex)) {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'passwordSpecialErrorText',
      );
    }

    return null;
  }

  static String? confirmPasswordValidator(
    BuildContext context,
    String? password,
    String? value,
  ) {
    if (password != value) {
      return Utils.getTranslated(
        context,
        AppPageConstants.SIGNUPPAGE,
        'passwordNotMatch',
      );
    }
    return null;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
