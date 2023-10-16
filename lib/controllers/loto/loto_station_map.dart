import 'dart:async';

import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/dio/api/loto_api.dart';
import 'package:samsung_sss_flutter/models/json/loto/loto_map_model.dart';
import 'package:samsung_sss_flutter/models/json/loto/loto_panel_model.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';

import '../../../const/app_color.dart';
import '../../../const/app_font.dart';
import '../../const/app_page_constant.dart';
import '../../const/utils.dart';
import '../../models/enum/status_enum.dart';
import '../../models/page_argument/loto_building_argument.dart';

class StationMapScreen extends StatefulWidget {
  final LotoBuildingArguments buildingId;
  const StationMapScreen({Key? key, required this.buildingId})
      : super(key: key);

  @override
  State<StationMapScreen> createState() => _StationMapScreenState();
}

class _StationMapScreenState extends State<StationMapScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? tabController;
  int currentTab = 0;
  bool isLoading = true;
  bool isMapLoading = true;
  bool isPanelLoading = true;
  var mapUISpace = GlobalKey<ScaffoldState>();
  double? mapSpace;
  int page = 1;
  int size = 20;
  int? totalPanel;
  bool hasNextPage = false;
  bool noMoreData = false;
  bool displayNoData = true;
  bool panelLoading = false;

  final ScrollController _scrollController = ScrollController();
  List<Result> panelList = [];
  LotoMapModel? buildingMap;

  Future<LotoMapModel> getBuildingList() async {
    LOTOApi lotoApi = LOTOApi(context);
    return lotoApi.getBuildingMap(widget.buildingId.id);
  }

  Future<LotoPanelModel> getPanelList() async {
    LOTOApi lotoApi = LOTOApi(context);
    return lotoApi.getPanelList(page, size, widget.buildingId.id);
  }

  //Function starts here

  callGetPanelList(BuildContext context) async {
    await getPanelList().then((value) async {
      setState(() {
        panelList = [...panelList, ...value.result!];
        totalPanel == null ? totalPanel = value.total ?? 0 : null;
        if (value.total! > panelList.length) {
          hasNextPage = true;
        } else {
          hasNextPage = false;
        }
        if (value.result!.isEmpty) {
          noMoreData = true;
        }
      });
    },
        onError: (e) => {
              Utils.handleError(context, e),
            }).whenComplete(() {
      isPanelLoading = false;

      panelLoading = false;
    });
  }

  callGetPanelMap(BuildContext context) async {
    await getBuildingList().then((value) async {
      setState(() {
        buildingMap = value;
      });
    },
        onError: (e) => {
              Utils.handleError(context, e),
            }).whenComplete(() {
      setState(() {
        isMapLoading = false;
      });
    });
  }

  onLoadCall() async {
    await callGetPanelMap(context);
    await callGetPanelList(context);
  }

  void calculateEmptySpace(double availableHeight) {
    !isMapLoading
        ? WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              mapSpace = mapUISpace.currentContext?.size!.height;
            });
          })
        : null;
  }

  void _loadMore() {
    panelLoading ? null : callGetPanelList(context);
    setState(() {
      panelLoading = true;
    });
  }

  void _gotoDetail(String panelId) {
    Navigator.pushNamed(context, AppRoutes.lotoPanelDetailRoute,
        arguments: LotoPanelArguments(id: panelId));
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_LOTO_MAP_SCREEN);
    tabController = TabController(length: 2, vsync: this);
    onLoadCall();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (noMoreData || !hasNextPage || panelList.length >= totalPanel!) {
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              displayNoData = false;
            });
          });
          return;
        } else {
          page += 1;
          _loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    super.dispose();
  }

  Color getStatusColor(Status status) {
    switch (status) {
      case Status.ACTIVE:
        return AppColor.activeGreen;
      case Status.ISOLATED:
        return AppColor.redDot;
      case Status.NONE:
        return AppColor.noneGrey;
    }
  }

  String getStatusText(Status status) {
    switch (status) {
      case Status.ACTIVE:
        return Utils.getTranslated(
            context, AppPageConstants.LOTOMODULE, 'panelOn');
      case Status.ISOLATED:
        return Utils.getTranslated(
            context, AppPageConstants.LOTOMODULE, 'panelOff');
      case Status.NONE:
        return '';
    }
  }

  TextStyle? getStatusStyle(Status status) {
    switch (status) {
      case Status.ACTIVE:
        return AppFont.helveticaNeueMedium(12,
            color: AppColor.wordingColorBlack);
      case Status.ISOLATED:
        return AppFont.helveticaNeueMedium(12,
            color: AppColor.wordingColorWhite);
      case Status.NONE:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewPadding.bottom -
        kToolbarHeight;

    calculateEmptySpace(availableHeight);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _stationMapPageAppbar(),
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
                _stationMapPageTitle(widget.buildingId.name),
                _stationTabbar(screenWidth),
                _stationTabView(screenWidth),
              ],
            ),
          ),
        ));
  }

  Expanded _stationTabView(double screenWidth) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          _stationMapTab(screenWidth),
          _stationPanelList(screenWidth),
        ],
      ),
    );
  }

  Widget _stationMapTab(double screenWidth) {
    return !isMapLoading
        ? buildingMap?.rows != null
            ? buildingMap!.rows!.isNotEmpty
                ? Container(
                    key: mapUISpace,
                    margin: const EdgeInsets.only(bottom: 94.0),
                    child: RefreshIndicator(
                      onRefresh: () {
                        setState(() {
                          isMapLoading = true;
                        });
                        return callGetPanelMap(context);
                      },
                      child: Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.borderGrey),
                        ),
                        child: SizedBox(
                          width: screenWidth,
                          child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(17, 32, 22, 2),
                              itemCount: buildingMap!.rows!.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return stationMapItem(
                                    screenWidth,
                                    buildingMap!.rows![index],
                                    widget.buildingId.row,
                                    widget.buildingId.col);
                              }),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      Utils.getTranslated(context, AppPageConstants.LOTOMODULE,
                          'emtpyPanelMap'),
                    ),
                  )
            : Center(
                child: Text(
                  Utils.getTranslated(
                      context, AppPageConstants.LOTOMODULE, 'emtpyPanelMap'),
                ),
              )
        : Center(
            child: CircularProgressIndicator(
              color: AppColor.samsungBlue,
            ),
          );
  }

  Widget _stationPanelList(double screenWidth) {
    return isPanelLoading
        ? Center(
            child: CircularProgressIndicator(
            color: AppColor.samsungBlue,
          ))
        : panelList.isEmpty
            ? Center(
                child: Text(Utils.getTranslated(
                    context, AppPageConstants.LOTOMODULE, 'emtpyPanelList')),
              )
            : RefreshIndicator(
                onRefresh: () {
                  setState(() {
                    isPanelLoading = true;
                    panelList.clear();
                  });
                  return callGetPanelList(context);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      panelList.length + 1, // +1 for loading widget below
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index < panelList.length) {
                      return dataItem(screenWidth, panelList[index]);
                    } else {
                      if (panelLoading == true) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.samsungBlue,
                            ),
                          ),
                        );
                      }

                      // When nothing else to load
                      if (hasNextPage == false) {
                        return AnimatedOpacity(
                          opacity: displayNoData ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 40),
                            child: Center(
                              child: Text(
                                Utils.getTranslated(
                                  context,
                                  AppPageConstants.CHEMICALREGISTER,
                                  'noMoreItem',
                                ),
                                style: AppFont.helveticaNeueBold(14),
                              ),
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }
                  },
                ),
              );
  }

  Widget _stationTabbar(double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      child: TabBar(
        unselectedLabelColor: AppColor.samsungBlue.withOpacity(0.6),
        unselectedLabelStyle: AppFont.helveticaNeueBold(
          16,
        ),
        isScrollable: false,
        labelPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        onTap: (value) {
          setState(() {
            currentTab = value;
          });
        },
        labelStyle: AppFont.helveticaNeueBold(16, color: AppColor.samsungBlue),
        labelColor: AppColor.samsungBlue,
        controller: tabController,
        indicatorColor: AppColor.wordingColorWhite,
        tabs: [
          Container(
            width: screenWidth * 0.5,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: currentTab == 0
                            ? AppColor.samsungBlue
                            : AppColor.borderGrey,
                        width: 2))),
            child: Tab(
              iconMargin: EdgeInsets.zero,
              text: Utils.getTranslated(
                  context, AppPageConstants.LOTOMODULE, 'panelMapTabTitle'),
            ),
          ),
          Container(
            width: screenWidth * 0.5,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: currentTab == 1
                            ? AppColor.samsungBlue
                            : AppColor.borderGrey,
                        width: 2))),
            child: Tab(
                iconMargin: EdgeInsets.zero,
                text: Utils.getTranslated(
                    context, AppPageConstants.LOTOMODULE, 'panelListTabTitle')),
          ),
        ],
      ),
    );
  }

  Widget stationMapItem(
    double screenWidth,
    BuildingRow rows,
    int rowCount,
    int totalLens,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 36),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var x = 0; x < totalLens; x++) panelUI(rows, x, totalLens)
      ]),
    );
  }

  Widget panelUI(BuildingRow rows, int x, int totalLens) {
    return rows.col!.any((element) => element.colNo == x)
        ? rows.col!
                .firstWhere((element) => element.colNo == x)
                .panelId!
                .isNotEmpty
            ? Builder(builder: (context) {
                final buildingCol =
                    rows.col!.firstWhere((element) => element.colNo == x);
                final status = getStatusFromString(buildingCol.status);
                return InkWell(
                  onTap: status == Status.NONE
                      ? null
                      : () => _gotoDetail(buildingCol.panelId!),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    height: 72,
                    width: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.borderGrey),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(status),
                      ),
                      child: FittedBox(
                        child: Text(
                          getStatusText(status),
                          style: getStatusStyle(status),
                        ),
                      ),
                    ),
                  ),
                );
              })
            : Container(
                margin: const EdgeInsets.fromLTRB(2, 2, 2, 0),
                padding: const EdgeInsets.all(2),
                height: 72,
                width: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.borderGrey, width: 2),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: AppColor.wordingColorGrey),
                ),
              )
        : Container(
            margin: const EdgeInsets.fromLTRB(2, 2, 2, 15),
            padding: const EdgeInsets.all(2),
            height: 72,
            width: 32,
          );
  }

  Widget dataItem(double screenWidth, Result data) {
    if (getStatusFromString(data.status) == Status.NONE) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => _gotoDetail(data.id!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 21),
        height: 60,
        decoration: BoxDecoration(
          color: getStatusFromString(data.status) == Status.ISOLATED
              ? AppColor.redBorder.withOpacity(0.1)
              : null,
          border: Border.all(
              color: getStatusFromString(data.status) == Status.ISOLATED
                  ? AppColor.redBorder
                  : AppColor.borderGrey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.7,
              child: Text(
                data.name ?? '',
                style: AppFont.helveticaNeueBold(14,
                    color: AppColor.wordingColorBlack),
              ),
            ),
            Image.asset(
              AppImage.rightArrowButton,
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }

  Widget _stationMapPageTitle(String title) {
    return CustomPageTitle(
      title: title,
      margin: const EdgeInsets.only(bottom: 30),
    );
  }

  AppBar _stationMapPageAppbar() {
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
