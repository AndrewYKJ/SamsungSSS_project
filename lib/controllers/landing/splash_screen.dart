import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/cache/app_cache.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/dio/api/user_api.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';

import '../../models/json/user/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  //Overrides starts here
  @override
  void initState() {
    super.initState();

    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_SPLASH_SCREEN);
    AppCache.getStringValue(AppCache.ACCESS_TOKEN_PREF).then(
      (value) => value.isNotEmpty ? getUserInfo(context) : startTimer(),
    );
  }

  //API Functions starts here

  Future<UserModel> getUser() async {
    UserApi userApi = UserApi(context);
    return userApi.getUser();
  }

  //Function starts here
  Future<void> getUserInfo(BuildContext context) async {
    await getUser().then((value) async {
      if (value.code == null) {
        AppCache.me = value;
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.homeRoute, (route) => false);
      } else {
        Utils.printInfo('LOGIN ERROR: ${value.message}');
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.loginRoute, (route) => false);
      }
    },
        onError: (e) => {
              Utils.handleError(context, e),
              AppCache.removeValues(context),
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.loginRoute, (route) => false),
            }).whenComplete(() {});
  }

  startTimer() {
    Future.delayed(const Duration(seconds: 1), (() {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.loginRoute, (route) => false);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImage.splashScreen),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
