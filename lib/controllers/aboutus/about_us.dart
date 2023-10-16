import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/widgets/custom_app_bar.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';

import '../../const/app_color.dart';
import '../../const/app_font.dart';
import '../../const/app_page_constant.dart';
import '../../const/utils.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_ABOUT_US_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              aboutUsPageTitle(context),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  AppImage.aboutUsBanner,
                  fit: BoxFit.contain,
                ),
              ),
              generateTitle(
                Utils.getTranslated(
                    context, AppPageConstants.ABOUTUS, 'contentTitle1'),
              ),
              generateContent(
                Utils.getTranslated(
                    context, AppPageConstants.ABOUTUS, 'contentDescription1'),
              ),
              generateContent(
                Utils.getTranslated(
                    context, AppPageConstants.ABOUTUS, 'contentDescription2'),
              ),
              generateTitle(
                Utils.getTranslated(
                    context, AppPageConstants.ABOUTUS, 'contentTitle2'),
              ),
              generateContent(
                Utils.getTranslated(
                    context, AppPageConstants.ABOUTUS, 'contentDescription3'),
              ),
              generateContent(
                Utils.getTranslated(
                    context, AppPageConstants.ABOUTUS, 'contentDescription4'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget aboutUsPageTitle(BuildContext context) {
    return CustomPageTitle(
      title: Utils.getTranslated(
              context, AppPageConstants.ABOUTUS, 'aboutUsPageTitle')
          .toUpperCase(),
    );
  }

  Widget generateTitle(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        style: AppFont.helveticaNeueBold(16, color: AppColor.samsungBlue),
      ),
    );
  }

  Widget generateContent(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        style: AppFont.helveticaNeueRegular(
          16,
          color: AppColor.wordingColorBlack,
        ),
      ),
    );
  }
}
