import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/dio/api/loto_api.dart';
import 'package:samsung_sss_flutter/models/json/loto/loto_buidling_list_model.dart';
import 'package:samsung_sss_flutter/models/page_argument/loto_building_argument.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';

import '../../../const/app_color.dart';
import '../../../const/app_font.dart';
import '../../const/app_page_constant.dart';
import '../../const/utils.dart';

class LotoListScreen extends StatefulWidget {
  const LotoListScreen({Key? key}) : super(key: key);

  @override
  State<LotoListScreen> createState() => _LotoListScreenState();
}

class _LotoListScreenState extends State<LotoListScreen> {
  List<LotoBuildingDetails> buildingList = [];
  bool isLoading = true;
  Future<List<LotoBuildingDetails>> getBuildingList() async {
    LOTOApi lotoApi = LOTOApi(context);
    return lotoApi.getAllBuilding();
  }

  //Function starts here
  callGetBuildingList(BuildContext context) async {
    await getBuildingList().then((value) async {
      setState(() {
        buildingList = value;
      });
    },
        onError: (e) => {
              Utils.handleError(context, e),
            }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_LOTO_LIST_SCREEN);
    callGetBuildingList(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _lotoListPageAppbar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          color: Colors.white,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPageTitle(
                title: Utils.getTranslated(
                  context,
                  AppPageConstants.LOTOMODULE,
                  'lotoStationListTitle',
                ),
                margin: const EdgeInsets.only(bottom: 30),
              ),
              Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.samsungBlue,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () {
                            setState(() {
                              isLoading = true;
                            });
                            return callGetBuildingList(context);
                          },
                          child: ListView.builder(
                              itemCount: buildingList.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return dataItem(
                                  screenWidth,
                                  buildingList[index],
                                );
                              }),
                        )),
            ],
          ),
        ),
      ),
    );
  }

  Widget dataItem(double screenWidth, LotoBuildingDetails data) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.lotoMapRoute,
          arguments: LotoBuildingArguments(
              id: data.id!,
              row: data.rowUnit!,
              col: data.colUnit!,
              name: data.name!)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.borderGrey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 80,
              color: AppColor.samsungBlue,
              margin: const EdgeInsets.only(right: 20),
              child: Image.network(
                data.image?.url ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(AppImage.placeholder);
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: Text(
                    "${data.name}",
                    style: AppFont.helveticaNeueBold(
                      16,
                      color: AppColor.wordingColorBlack,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: Utils.getTranslated(
                          context,
                          AppPageConstants.LOTOMODULE,
                          'lotoBuidlingTotailUnit',
                        ),
                        style: AppFont.helveticaNeueRegular(
                          14,
                          color: AppColor.wordingColorGrey,
                        ),
                      ),
                      TextSpan(
                        text: "${data.totalUnit}",
                        style: AppFont.helveticaNeueMedium(14,
                            color: AppColor.wordingColorBlack),
                      ),
                    ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    dotOnOffItem(
                        data.totalActive.toString(), AppColor.activeGreen),
                    dotOnOffItem(
                        data.totalInactive.toString(), AppColor.redDot),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget dotOnOffItem(String data, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          Text(
            data,
            style: AppFont.helveticaNeueMedium(
              14,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _lotoListPageAppbar() {
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
