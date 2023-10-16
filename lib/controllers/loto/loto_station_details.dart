import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/dio/api/loto_api.dart';
import 'package:samsung_sss_flutter/models/enum/status_enum.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';
import 'package:samsung_sss_flutter/widgets/gallery_image.dart';

import '../../../const/app_color.dart';
import '../../../const/app_font.dart';
import '../../const/app_image.dart';
import '../../const/app_page_constant.dart';
import '../../const/utils.dart';
import '../../models/json/loto/loto_panel_detail.dart';
import '../../models/page_argument/loto_building_argument.dart';

class PanelDetailScreen extends StatefulWidget {
  final LotoPanelArguments building;
  const PanelDetailScreen({Key? key, required this.building}) : super(key: key);

  @override
  State<PanelDetailScreen> createState() => _PanelDetailScreenState();
}

class _PanelDetailScreenState extends State<PanelDetailScreen> {
  LotoPanelDetailModel? panelDetails;
  SwitchList? currentSwitch;
  bool isLoading = true;
  Future<LotoPanelDetailModel> getPanelDetail() async {
    LOTOApi lotoApi = LOTOApi(context);
    return lotoApi.getPanelDetail(widget.building.id);
  }

  //Function starts here

  callGetPanelDetail(BuildContext context) async {
    await getPanelDetail().then((value) async {
      setState(() {
        panelDetails = value;
        currentSwitch = value.switchList!.first;
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
        AnalyticsConstant.ANALYTICS_LOTO_PANEL_DETAIL_SCREEN);
    callGetPanelDetail(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _panelDetailAppBar(),
        body: !isLoading
            ? SafeArea(
                child: Container(
                  color: Colors.white,
                  width: screenWidth,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _stationMapPageTitle(screenWidth, context),
                        _switchListnImage(),
                        _switchDetail(screenWidth),
                        if (panelDetails?.images != null &&
                            panelDetails!.images!.isNotEmpty)
                          _panelImagesList(panelDetails!.images)
                      ],
                    ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }

  Widget _panelImagesList(images) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 33.0),
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
          SizedBox(
            height: 80,
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      images: images,
                      index: index,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _switchListnImage() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.25,
      ),
      margin: const EdgeInsets.only(bottom: 33),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              children:
                  panelDetails!.switchList!.map((e) => _switchItem(e)).toList(),
            ),
          ),
          Flexible(
            flex: 3,
            child: Image.network(
              currentSwitch?.image?.url ?? '',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                AppImage.placeholder,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _switchItem(SwitchList data) {
    return InkWell(
      onTap: () {
        setState(() {
          currentSwitch = data;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: EdgeInsets.only(
          right: 30,
          bottom: currentSwitch!.id == data.id ? 6 : 0,
          top: currentSwitch!.id == data.id ? 6 : 0,
        ),
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
                color: currentSwitch!.id == data.id
                    ? AppColor.samsungBlue
                    : AppColor.borderGrey,
                width: currentSwitch!.id == data.id ? 4 : 1,
                strokeAlign: BorderSide.strokeAlignOutside)),
        child: Container(
          decoration: BoxDecoration(
              color: getStatusFromString(data.status) == Status.ACTIVE
                  ? AppColor.activeGreen
                  : AppColor.inactiveRed),
          child: Center(
              child: Text(
            data.switchNo ?? '',
            style: AppFont.helveticaNeueMedium(16,
                color: getStatusFromString(data.status) == Status.ACTIVE
                    ? AppColor.wordingColorBlack
                    : AppColor.wordingColorWhite),
          )),
        ),
      ),
    );
  }

  Container _switchDetail(double screenWidth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 35),
      margin: const EdgeInsets.only(bottom: 33),
      decoration: BoxDecoration(
        color: getStatusFromString(currentSwitch?.status) == Status.ACTIVE
            ? AppColor.activeGreen.withOpacity(0.1)
            : AppColor.redBorder.withOpacity(0.1),
        border: Border.all(
          color: getStatusFromString(currentSwitch?.status) == Status.ACTIVE
              ? AppColor.activeGreen
              : AppColor.redBorder,
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _switchTitle(),
            _switchPFU(),
            _switchRow1Details(screenWidth),
            _switchRow2Details(screenWidth),
            _switchRow3Details(screenWidth),
            _switchStatus(),
          ]),
    );
  }

  Widget _switchTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        Utils.getTranslated(
            context, AppPageConstants.LOTOMODULE, 'switchDetailTitle'),
        style: AppFont.helveticaNeueBold(16, color: AppColor.wordingColorBlack),
      ),
    );
  }

  Widget _switchStatus() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(
              context, AppPageConstants.LOTOMODULE, 'switchDetailStatus'),
          style: AppFont.helveticaNeueRegular(14,
              color: AppColor.wordingColorGrey),
        ),
        Text(
          getStatusFromString(currentSwitch?.status) == Status.ACTIVE
              ? Utils.getTranslated(
                  context, AppPageConstants.LOTOMODULE, 'panelOn')
              : Utils.getTranslated(
                  context, AppPageConstants.LOTOMODULE, 'panelOff'),
          style: AppFont.helveticaNeueBold(14, color: AppColor.activeGreen),
        ),
      ],
    );
  }

  Widget _switchRow3Details(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _switchUnitNo(screenWidth),
          _switchRating(),
        ],
      ),
    );
  }

  Widget _switchRating() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(
              context, AppPageConstants.LOTOMODULE, 'switchDetailRating'),
          style: AppFont.helveticaNeueRegular(14,
              color: AppColor.wordingColorGrey),
        ),
        Text(
          currentSwitch?.rating ?? '',
          style: AppFont.helveticaNeueMedium(14,
              color: AppColor.wordingColorBlack),
        ),
      ],
    );
  }

  Column _switchUnitNo(double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: (screenWidth - 32 - 32) * .5,
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.LOTOMODULE, 'switchDetailUnitNo'),
            style: AppFont.helveticaNeueRegular(14,
                color: AppColor.wordingColorGrey),
          ),
        ),
        Text(
          currentSwitch?.unitNo ?? '',
          style: AppFont.helveticaNeueMedium(14,
              color: AppColor.wordingColorBlack),
        ),
      ],
    );
  }

  Widget _switchRow2Details(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _switchFeederTag(screenWidth),
          _switchService(),
        ],
      ),
    );
  }

  Column _switchService() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(
              context, AppPageConstants.LOTOMODULE, 'switchDetailService'),
          style: AppFont.helveticaNeueRegular(14,
              color: AppColor.wordingColorGrey),
        ),
        Text(
          currentSwitch?.service ?? '',
          style: AppFont.helveticaNeueMedium(14,
              color: AppColor.wordingColorBlack),
        ),
      ],
    );
  }

  Column _switchFeederTag(double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: (screenWidth - 32 - 32) * .5,
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.LOTOMODULE, 'switchDetailFeederTag'),
            style: AppFont.helveticaNeueRegular(14,
                color: AppColor.wordingColorGrey),
          ),
        ),
        Text(
          currentSwitch?.feederTag ?? '',
          style: AppFont.helveticaNeueMedium(14,
              color: AppColor.wordingColorBlack),
        ),
      ],
    );
  }

  Widget _switchRow1Details(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _switchIdNo(screenWidth),
          _switchEDIC(),
        ],
      ),
    );
  }

  Column _switchEDIC() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(
              context, AppPageConstants.LOTOMODULE, 'switchDetailEIDC'),
          style: AppFont.helveticaNeueRegular(14,
              color: AppColor.wordingColorGrey),
        ),
        Text(
          currentSwitch?.edicno ?? '',
          style: AppFont.helveticaNeueMedium(14,
              color: AppColor.wordingColorBlack),
        ),
      ],
    );
  }

  Column _switchIdNo(double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: (screenWidth - 32 - 32) * .5,
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.LOTOMODULE, 'switchDetailSwitchNo'),
            style: AppFont.helveticaNeueRegular(14,
                color: AppColor.wordingColorGrey),
          ),
        ),
        Text(
          currentSwitch?.switchNo ?? '',
          style: AppFont.helveticaNeueMedium(14,
              color: AppColor.wordingColorBlack),
        ),
      ],
    );
  }

  Widget _switchPFU() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(
                context, AppPageConstants.LOTOMODULE, 'switchDetailPfU'),
            style: AppFont.helveticaNeueRegular(14,
                color: AppColor.wordingColorGrey),
          ),
          Text(
            '${panelDetails?.name} (${currentSwitch?.name})',
            style: AppFont.helveticaNeueMedium(14,
                color: AppColor.wordingColorBlack),
          ),
        ],
      ),
    );
  }

  Widget _stationMapPageTitle(double screenWidth, BuildContext context) {
    return CustomPageTitle(
      title: '${panelDetails?.name} (${currentSwitch?.name})',
      margin: const EdgeInsets.only(
        bottom: 55,
      ),
    );
  }

  AppBar _panelDetailAppBar() {
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
