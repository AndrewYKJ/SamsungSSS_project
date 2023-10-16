import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';

import '../../../const/app_color.dart';
import '../../../const/app_font.dart';
import '../../../const/app_page_constant.dart';
import '../../../const/utils.dart';
import '../../../routes/approutes.dart';

class ForgotPwdSuccessScreen extends StatefulWidget {
  const ForgotPwdSuccessScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPwdSuccessScreen> createState() => _ForgotPwdSuccessScreenState();
}

class _ForgotPwdSuccessScreenState extends State<ForgotPwdSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_FORGOT_PASSWORD_SUCCESS_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
          child: Container(
            color: Colors.white,
            width: screenWidth,
            height: availableHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _successUI(screenWidth, context),
                _doneBtn(screenWidth)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _successUI(double screenWidth, BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _successImage(),
          _successTitle(screenWidth, context),
          _successDesc(screenWidth, context),
        ],
      ),
    );
  }

  Widget _successDesc(double screenWidth, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 78,
      ),
      child: Text(
        Utils.getTranslated(
            context, AppPageConstants.FORGOTPASSWORDPAGE, 'successDesc'),
        style: AppFont.helveticaNeueRegular(
          16,
          color: AppColor.wordingColorBlack,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _successTitle(double screenWidth, BuildContext context) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(
        bottom: 11,
      ),
      child: Center(
        child: Text(
          Utils.getTranslated(
              context, AppPageConstants.FORGOTPASSWORDPAGE, 'success'),
          style: AppFont.helveticaNeueBold(30, color: AppColor.samsungBlue),
        ),
      ),
    );
  }

  Widget _successImage() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 47,
      ),
      child: Image.asset(
        AppImage.successResetPasswordIcon,
        height: 72,
        width: 72,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _doneBtn(double screenWidth) {
    return InkWell(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.loginRoute, (route) => false);
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 78,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.samsungBlue),
        child: Center(
          child: Text(
            Utils.getTranslated(
                    context, AppPageConstants.FORGOTPASSWORDPAGE, 'doneBtn')
                .toUpperCase(),
            style: AppFont.helveticaNeueBold(16,
                color: AppColor.wordingColorWhite),
          ),
        ),
      ),
    );
  }
}
