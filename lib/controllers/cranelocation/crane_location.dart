import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/const/constants.dart';
import 'package:samsung_sss_flutter/dio/api/crane_api.dart';
import 'package:samsung_sss_flutter/models/json/crane/crane_model.dart';
import 'package:samsung_sss_flutter/models/page_argument/pdf.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_app_bar.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';
import 'package:samsung_sss_flutter/widgets/gallery_image.dart';
import 'package:samsung_sss_flutter/widgets/file_list_tile.dart';

import '../../const/app_color.dart';
import '../../const/app_font.dart';
import '../../const/app_page_constant.dart';
import '../../const/utils.dart';

class CraneLocationScreen extends StatefulWidget {
  const CraneLocationScreen({Key? key}) : super(key: key);

  @override
  State<CraneLocationScreen> createState() => _CraneLocationScreenState();
}

class _CraneLocationScreenState extends State<CraneLocationScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;
  late CraneApi craneApi;
  String oneTimeToken = '';
  String craneId = '';

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_CRANE_LOCATION_SCREEN);
    craneApi = CraneApi(context);

    setOneTimeToken();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: AppColor.samsungBlue,
      ),
      onRefresh: () async {
        await setOneTimeToken();
        if (Platform.isAndroid) {
          webViewController?.reload();
        }
      },
    );
  }

  Future<void> setOneTimeToken() async {
    craneApi.getOneTimeToken().then((value) {
      setState(() {
        oneTimeToken = value.token;
      });

      webViewController?.loadUrl(
          urlRequest: URLRequest(
        url: Uri.parse(Constants.CRANEWEBVIEWURL + oneTimeToken),
      ));
    }).onError((error, stackTrace) {
      Utils.handleError(context, error);
    });
  }

  Future<Crane> getCraneDetail() async {
    return craneApi.getCraneDetail(craneId);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              craneLocationPageTitle(context),
              craneLocationDesc(context),
              webView(oneTimeToken, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  callPopUp(double screenheight) {
    return showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      builder: (ctx) => FutureBuilder(
          future: getCraneDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    Utils.getTranslated(
                      context,
                      AppPageConstants.UTILITY,
                      'general_alert_message_error_response',
                    ),
                  ),
                );
              }
              final crane = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 22,
                ),
                child: SizedBox(
                  height: screenheight * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            AppImage.closeButton,
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          Utils.getTranslated(
                            context,
                            AppPageConstants.CRANELOC,
                            'craneDetailTitle',
                          ),
                          style: AppFont.helveticaNeueBold(16,
                              color: AppColor.wordingColorBlack),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${Utils.getTranslated(
                                  context,
                                  AppPageConstants.CRANELOC,
                                  'subcontractor',
                                )}:",
                                style: AppFont.helveticaNeueRegular(14,
                                    color: AppColor.wordingColorGrey)),
                            Text(
                              crane.subContractorName,
                              style: AppFont.helveticaNeueMedium(14,
                                  color: AppColor.wordingColorBlack),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${Utils.getTranslated(
                                  context,
                                  AppPageConstants.CRANELOC,
                                  'location',
                                )}:",
                                style: AppFont.helveticaNeueRegular(14,
                                    color: AppColor.wordingColorGrey)),
                            Text(
                              crane.location,
                              style: AppFont.helveticaNeueMedium(14,
                                  color: AppColor.wordingColorBlack),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${Utils.getTranslated(
                                  context,
                                  AppPageConstants.CRANELOC,
                                  'date',
                                )}:",
                                style: AppFont.helveticaNeueRegular(14,
                                    color: AppColor.wordingColorGrey)),
                            Text(
                              Utils.displayDateFormat.format(crane.updatedAt),
                              style: AppFont.helveticaNeueMedium(14,
                                  color: AppColor.wordingColorBlack),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 34.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${Utils.getTranslated(
                                context,
                                AppPageConstants.CRANELOC,
                                'liftingSpvr',
                              )}:",
                              style: AppFont.helveticaNeueRegular(14,
                                  color: AppColor.wordingColorGrey),
                            ),
                            Text(
                              crane.liftingSupervisor,
                              style: AppFont.helveticaNeueMedium(14,
                                  color: AppColor.wordingColorBlack),
                            )
                          ],
                        ),
                      ),
                      if (crane.images?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Utils.getTranslated(
                                  context,
                                  AppPageConstants.CRANELOC,
                                  'photo',
                                ),
                                style: AppFont.helveticaNeueRegular(14,
                                    color: AppColor.wordingColorGrey),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              SizedBox(
                                height: 80,
                                child: GridView.builder(
                                  itemCount: crane.images!.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                  ),
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: GridTile(
                                        child: GalleryImage(
                                          images: crane.images!,
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (crane.liftingPlan != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${Utils.getTranslated(
                                  context,
                                  AppPageConstants.CRANELOC,
                                  'liftingPlan',
                                )}:",
                                style: AppFont.helveticaNeueRegular(14,
                                    color: AppColor.wordingColorGrey),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FileListTile(
                                fileName: crane.liftingPlan!.fileName,
                                url: crane.liftingPlan!.url,
                                imagePath: AppImage.pdfIcon,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.pdfViewRoute,
                                    arguments: PdfPropeties(
                                      url: crane.liftingPlan!.url,
                                      name: crane.liftingPlan!.fileName,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Container craneLocationDesc(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Text(
        Utils.getTranslated(context, AppPageConstants.CRANELOC, 'craneLocDesc'),
        style: AppFont.helveticaNeueBold(16, color: AppColor.wordingColorBlack),
      ),
    );
  }

  Widget craneLocationPageTitle(BuildContext context) {
    return CustomPageTitle(
      title: Utils.getTranslated(
              context, AppPageConstants.CRANELOC, 'craneLocPageTitle')
          .toUpperCase(),
      margin: const EdgeInsets.only(bottom: 14),
    );
  }

  Widget webView(String token, double screenHeight) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: InAppWebView(
          key: webViewKey,
          initialOptions: options,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller
              ..addJavaScriptHandler(
                handlerName: "getMapPin",
                callback: (args) {
                  final String id = args[0]["PIN_VAL"] as String;
                  setState(() {
                    craneId = id;
                  });
                  callPopUp(0.90 * screenHeight);
                },
              )
              ..addJavaScriptHandler(
                handlerName: "allowAccess",
                callback: (args) {
                  final errorMessage = args[0]["ERROR"]["message"] as String;
                  Utils.showAlertDialog(
                    context,
                    Utils.getTranslated(
                      context,
                      AppPageConstants.UTILITY,
                      'alert_dialog_title_error_text',
                    ),
                    errorMessage,
                  );
                },
              );

            webViewController!.loadUrl(
                urlRequest: URLRequest(
              url: Uri.parse(Constants.CRANEWEBVIEWURL + oneTimeToken),
            ));
          },
          onLoadStop: (controller, url) {
            pullToRefreshController.endRefreshing();
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController.endRefreshing();
            }
          },
        ),
      ),
    );
  }
}
