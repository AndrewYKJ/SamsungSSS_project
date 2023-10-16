import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:samsung_sss_flutter/cache/app_cache.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/models/json/user/user_model.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';

import '../../const/app_color.dart';
import '../../const/app_font.dart';
import '../../const/app_page_constant.dart';
import '../../const/utils.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_ACCOUNT_INFO_SCREEN);
    setUser();
  }

  void setUser() {
    user = AppCache.me!;
  }

  String getFormattedDob(String dob) {
    DateTime originalDate = DateTime.parse(dob);
    return DateFormat('dd MMMM yyyy').format(originalDate);
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
      appBar: _accountinfoAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Container(
            color: Colors.white,
            width: screenWidth,
            height: availableHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _accountinfoPageTitle(screenWidth, context),
                _accountinfoSummary(screenWidth, context),
                _emtpySpace(),
                _accountInfoDetail(screenWidth, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accountInfoDetail(double screenWidth, BuildContext context) {
    return Column(
      children: [
        _emailAddress(screenWidth, context),
        _dob(screenWidth, context),
        _phoneNo(screenWidth, context),
        _companyName(screenWidth, context),
      ],
    );
  }

  Column _companyName(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 9),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.EDITACCOUNT, 'companyNameFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              14,
              color: AppColor.wordingColorBlack.withOpacity(0.6),
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 26),
          child: Text(
            user.company!,
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
      ],
    );
  }

  Column _phoneNo(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 9),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.EDITACCOUNT, 'phoneNoFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              14,
              color: AppColor.wordingColorBlack.withOpacity(0.6),
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 26),
          child: Text(
            Utils.formatPhoneNumber(user.mobileNo!),
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
      ],
    );
  }

  Column _dob(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 9),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.EDITACCOUNT, 'dobFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              14,
              color: AppColor.wordingColorBlack.withOpacity(0.6),
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 26),
          child: Text(
            getFormattedDob(user.dob!),
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
      ],
    );
  }

  Column _emailAddress(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 9),
          child: Text(
            Utils.getTranslated(context, AppPageConstants.EDITACCOUNT,
                'emailAddressFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              14,
              color: AppColor.wordingColorBlack.withOpacity(0.6),
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 26),
          child: Text(
            user.username!,
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emtpySpace() {
    return const SizedBox(
      height: 42,
    );
  }

  Row _accountinfoSummary(double screenWidth, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Image.asset(
                AppImage.placeholder,
                height: 60,
                width: 60,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.account_circle_rounded,
                    size: 60,
                    color: AppColor.samsungBlue,
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 19.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          user.name!,
                          style: AppFont.helveticaNeueBold(16,
                              color: AppColor.wordingColorBlack),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${user.designation!}, ${user.department!}',
                        style: AppFont.helveticaNeueRegular(14,
                            color: AppColor.samsungBlue),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          iconSize: 24,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.editAccountRoute).then(
              (value) {
                final hasChanged = value != null ? value as bool : false;
                if (hasChanged) {
                  setState(() {
                    setUser();
                  });
                }
              },
            );
          },
        )
      ],
    );
  }

  Widget _accountinfoPageTitle(double screenWidth, BuildContext context) {
    return CustomPageTitle(
      title: Utils.getTranslated(
              context, AppPageConstants.EDITACCOUNT, 'accountPageTitle')
          .toUpperCase(),
      margin: const EdgeInsets.only(bottom: 30),
    );
  }

  AppBar _accountinfoAppBar() {
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
}
