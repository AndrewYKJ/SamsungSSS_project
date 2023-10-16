import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';

import '../../../const/app_color.dart';
import '../../../const/app_font.dart';
import '../../../const/app_page_constant.dart';
import '../../../widgets/custom_textfield.dart';

class ForgotPwdScreen extends StatefulWidget {
  const ForgotPwdScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPwdScreen> createState() => _ForgotPwdScreenState();
}

class _ForgotPwdScreenState extends State<ForgotPwdScreen> {
  TextEditingController fgtPwdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_FORGOT_PASSWORD_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewPadding.bottom -
        kToolbarHeight;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: forgotPageAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => Utils.unfocusContext(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              color: Colors.white,
              width: screenWidth,
              height: availableHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  forgotPageTitle(screenWidth, context),
                  forgotPageDesc(screenWidth, context),
                  _emailAddress(screenWidth),
                  const Spacer(),
                  _submitBtn(screenWidth)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container forgotPageDesc(double screenWidth, BuildContext context) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(
        bottom: 26,
      ),
      child: Text(
        Utils.getTranslated(
            context, AppPageConstants.FORGOTPASSWORDPAGE, 'forgotPasswordDesc'),
        style:
            AppFont.helveticaNeueRegular(16, color: AppColor.wordingColorBlack),
      ),
    );
  }

  Container forgotPageTitle(double screenWidth, BuildContext context) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(
        bottom: 11,
      ),
      child: Text(
        Utils.getTranslated(context, AppPageConstants.FORGOTPASSWORDPAGE,
                'forgotPasswordTitle')
            .toUpperCase(),
        style: AppFont.helveticaNeueBold(30, color: AppColor.samsungBlue),
      ),
    );
  }

  AppBar forgotPageAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: Image.asset(AppImage.backButton),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }),
    );
  }

  Widget _submitBtn(double screenWidth) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.forgotPwdSuccessRoute, (route) => false);
        }
      },
      child: Container(
        width: screenWidth,
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 78),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.samsungBlue),
        child: Center(
          child: Text(
            Utils.getTranslated(
                    context, AppPageConstants.FORGOTPASSWORDPAGE, 'submitBtn')
                .toUpperCase(),
            style: AppFont.helveticaNeueBold(16,
                color: AppColor.wordingColorWhite),
          ),
        ),
      ),
    );
  }

  Widget _emailAddress(double screenWidth) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Container(
            width: screenWidth,
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
          SizedBox(
            width: screenWidth,
            child: CustomTextField(
              controller: fgtPwdController,
              validator: (value) {
                return Utils.emailValidator(context, value);
              },
              hintText: Utils.getTranslated(
                  context, AppPageConstants.LOGINPAGE, 'emailAddressHintText'),
            ),
          ),
        ],
      ),
    );
  }
}
