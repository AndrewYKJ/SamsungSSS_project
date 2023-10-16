import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:samsung_sss_flutter/cache/app_cache.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/app_font.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/const/app_page_constant.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/dio/api/auth_api.dart';
import 'package:samsung_sss_flutter/dio/api/user_api.dart';
import 'package:samsung_sss_flutter/models/json/auth/login_model.dart';
import 'package:samsung_sss_flutter/models/json/user/user_model.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_button.dart';

import '../../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> with WidgetsBindingObserver {
  bool isLoading = true;
  var emailController = TextEditingController();
  var pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_LOGIN_SCREEN);
    AppCache.getStringValue(AppCache.ACCESS_TOKEN_PREF)
        .then((value) => value.isNotEmpty ? getUserInfo(context) : null);

    emailController.addListener(() {});
    pwdController.addListener(() {});
    WidgetsBinding.instance.addObserver(this);
  }

  //API Functions starts here
  Future<AuthModel> getLogin() async {
    AuthApi authApi = AuthApi(context);
    return authApi.login(context, emailController.text, pwdController.text);
  }

  Future<UserModel> getUser() async {
    UserApi userApi = UserApi(context);
    return userApi.getUser();
  }

  //Function starts here
  Future<void> getUserLogin() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    await getLogin().then((value) async {
      if (value.code == null) {
        AppCache.setAuthToken(value.accessToken!, value.refreshToken!);
        await getUserInfo(context);
      } else {
        Utils.printInfo('LOGIN ERROR: ${value.message}');
      }
    }, onError: (e) {
      Utils.handleError(context, e);
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  Future<void> getUserInfo(BuildContext context) async {
    await getUser().then((value) async {
      EasyLoading.dismiss();
      if (value.code == null) {
        AppCache.me = value;
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.homeRoute, (route) => false);
      } else {
        Utils.printInfo('LOGIN ERROR: ${value.message}');
      }
    }, onError: (e) {
      Utils.handleError(context, e);
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => Utils.unfocusContext(context),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _loginPageLogo(),
                    _loginPageTitle(),
                    _emailAddress(),
                    _password(),
                    _forgotPwd(),
                  ],
                ),
                Column(
                  children: [
                    _signInBtn(),
                    _signUpBtn(),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpBtn() {
    return CustomButton(
      context: context,
      color: AppColor.samsungBlack,
      function: () {
        Navigator.pushNamed(context, AppRoutes.signUpRoute);
      },
      text: Utils.getTranslated(context, AppPageConstants.LOGINPAGE, 'signUp')
          .toUpperCase(),
      font: AppFont.helveticaNeueBold(16, color: AppColor.wordingColorWhite),
    );
  }

  Widget _signInBtn() {
    return CustomButton(
        context: context,
        color: AppColor.samsungBlue,
        function: () async {
          if (emailController.text.isNotEmpty &&
              pwdController.text.isNotEmpty) {
            getUserLogin();
          }
        },
        text: Utils.getTranslated(context, AppPageConstants.LOGINPAGE, 'signIn')
            .toUpperCase(),
        font: AppFont.helveticaNeueBold(16, color: AppColor.wordingColorWhite));
  }

  Widget _forgotPwd() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 121),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.forgotPwdRoute);
            },
            child: Text(
              Utils.getTranslated(
                  context, AppPageConstants.LOGINPAGE, 'forgotPassword'),
              style: AppFont.helveticaNeueRegular(
                16,
                color: AppColor.wordingColorBlack,
              ),
            )),
      ),
    );
  }

  Widget _password() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              Utils.getTranslated(
                  context, AppPageConstants.LOGINPAGE, 'passwordFieldTitle'),
              style: AppFont.helveticaNeueRegular(
                16,
                color: AppColor.wordingColorBlack,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomTextField(
              controller: pwdController,
              obsure: true,
              hintText: Utils.getTranslated(
                  context, AppPageConstants.LOGINPAGE, 'passwordHintText'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailAddress() {
    return Container(
      margin: const EdgeInsets.only(bottom: 46),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              Utils.getTranslated(context, AppPageConstants.LOGINPAGE,
                  'emailAddressFieldTitle'),
              style: AppFont.helveticaNeueRegular(
                16,
                color: AppColor.wordingColorBlack,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: CustomTextField(
              controller: emailController,
              obsure: false,
              hintText: Utils.getTranslated(
                  context, AppPageConstants.LOGINPAGE, 'emailAddressHintText'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginPageTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(bottom: 44),
        child: Text(
          Utils.getTranslated(context, AppPageConstants.LOGINPAGE, 'signIn'),
          style: AppFont.helveticaNeueBold(30, color: AppColor.samsungBlue),
        ),
      ),
    );
  }

  Widget _loginPageLogo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(106, 54, 106, 77),
      child: AspectRatio(
        aspectRatio: 20 / 7,
        child: Image.asset(
          AppImage.samsungEngineeringLogo,
        ),
      ),
    );
  }

  //Widget function starts here
}
