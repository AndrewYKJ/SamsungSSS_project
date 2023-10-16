import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_page_constant.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/widgets/custom_app_bar.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';

class SdsSummary extends StatelessWidget {
  final String url;
  const SdsSummary({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_SDS_SUMMARY_SCREEN);

    return Scaffold(
      appBar: const CustomAppBar(showBackButton: true),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPageTitle(
                title: Utils.getTranslated(
                  context,
                  AppPageConstants.CHEMICALREGISTER,
                  'sdsSummary',
                ).toUpperCase(),
                margin: const EdgeInsets.only(bottom: 30),
              ),
              Image.network(url),
            ],
          ),
        ),
      ),
    );
  }
}
