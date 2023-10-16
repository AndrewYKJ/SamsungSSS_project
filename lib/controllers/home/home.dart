import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/cache/app_cache.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/const/app_page_constant.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/dio/api/user_api.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';

import '../../const/app_color.dart';
import '../../const/app_font.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fullName = "";
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_HOME_SCREEN);
    fullName = AppCache.me?.name ?? '';
  }

  void logout() {
    UserApi(context).logout().then((_) {
      AppCache.removeValues(context);
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.loginRoute, (route) => false);
    }).onError((error, _) {
      Utils.handleError(context, error);
    });
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 44, bottom: 30),
                        child: Center(
                          child: Image.asset(
                            AppImage.samsungEngineeringLogo,
                            fit: BoxFit.contain,
                            height: 50,
                          ),
                        ),
                      ),
                      _logoutBtn(context),
                    ],
                  ),
                  _welcomeUser(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Wrap(
                      runSpacing: 20,
                      spacing: 14,
                      children: [
                        _tagOutBtn(screenHeight, screenWidth),
                        _craneLocBtn(screenHeight, screenWidth),
                        _chemiRsgtrBtn(screenHeight, screenWidth),
                        _accountBtn(context, screenHeight, screenWidth),
                        _aboutUsBtn(screenHeight, screenWidth),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align _logoutBtn(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: IconButton(
          onPressed: logout,
          icon: Icon(
            Icons.logout,
            color: AppColor.wordingColorGrey,
          ),
        ),
      ),
    );
  }

  Widget _aboutUsBtn(double screenHeight, double screenWidth) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.aboutUsRoute);
      },
      child: Container(
        height: screenHeight * 0.1,
        width: screenWidth - 32,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: AppColor.samsungTeal.withOpacity(0.2),
            border: Border.all(color: AppColor.samsungTeal, width: 2)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                AppImage.aboutUsIcon,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.receipt_long),
              ),
            ),
            Text(
              Utils.getTranslated(
                  context, AppPageConstants.ABOUTUS, 'aboutUsPageTitle'),
              style: AppFont.helveticaNeueBold(14,
                  color: AppColor.wordingColorBlack),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _accountBtn(
      BuildContext context, double screenHeight, double screenWidth) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.accountInfoRoute);
      },
      child: Container(
        height: screenHeight * 0.25,
        width: screenWidth * .5 - 16 - 6,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: AppColor.samsungTeal.withOpacity(0.2),
            border: Border.all(color: AppColor.samsungTeal, width: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset(
                AppImage.accountIcon,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.key_sharp),
              ),
            ),
            Text(
              Utils.getTranslated(
                  context, AppPageConstants.EDITACCOUNT, 'accountPageTitle'),
              style: AppFont.helveticaNeueBold(14,
                  color: AppColor.wordingColorBlack),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chemiRsgtrBtn(double screenHeight, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.chemicalRegisterCategoryListRoute,
        );
      },
      child: Container(
        height: screenHeight * 0.25,
        width: screenWidth * .5 - 16 - 6,
        padding: const EdgeInsets.only(bottom: 12, left: 12),
        decoration: BoxDecoration(
            color: AppColor.samsungTeal.withOpacity(0.2),
            border: Border.all(color: AppColor.samsungTeal, width: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset(
                AppImage.chemicalRegisterIcon,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.one_x_mobiledata),
              ),
            ),
            Text(
              Utils.getTranslated(context, AppPageConstants.CHEMICALREGISTER,
                  'chemicalRegisterTitle'),
              style: AppFont.helveticaNeueBold(14,
                  color: AppColor.wordingColorBlack),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _craneLocBtn(double screenHeight, double screenWidth) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.craneLocationRoute);
      },
      child: Container(
        height: screenHeight * 0.25,
        width: screenWidth * .5 - 16 - 6,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: AppColor.samsungTeal.withOpacity(0.2),
            border: Border.all(color: AppColor.samsungTeal, width: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset(
                AppImage.craneLocationIcon,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.carpenter),
              ),
            ),
            Text(
              Utils.getTranslated(context, "CRANELOC", "craneLocPageTitle"),
              style: AppFont.helveticaNeueBold(14,
                  color: AppColor.wordingColorBlack),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagOutBtn(double screenHeight, double screenWidth) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.lotoListRoute);
      },
      child: Container(
        height: screenHeight * 0.25,
        width: screenWidth * .5 - 16 - 6,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColor.samsungTeal.withOpacity(0.2),
          border: Border.all(color: AppColor.samsungTeal, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset(AppImage.logoutTagoutIcon,
                  width: 54,
                  height: 54,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.alarm)),
            ),
            Text(
              Utils.getTranslated(
                  context, AppPageConstants.LOTOMODULE, 'lotoStationListTitle'),
              style: AppFont.helveticaNeueBold(14,
                  color: AppColor.wordingColorBlack),
            ),
          ],
        ),
      ),
    );
  }

  Container _welcomeUser() {
    return Container(
      margin: const EdgeInsets.only(bottom: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: 'Welcome, ',
              style: AppFont.helveticaNeueBold(16,
                  color: AppColor.wordingColorBlack),
              children: [
                TextSpan(
                  text: fullName,
                  style: AppFont.helveticaNeueBold(16,
                      color: AppColor.samsungBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
