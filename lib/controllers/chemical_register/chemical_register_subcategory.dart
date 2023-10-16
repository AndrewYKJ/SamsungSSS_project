import 'dart:async';

import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_font.dart';
import 'package:samsung_sss_flutter/const/app_page_constant.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/dio/api/chemical_register_api.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_model.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/result_list_chemical_model.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_app_bar.dart';
import 'package:samsung_sss_flutter/widgets/custom_list_tile.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';

class ChemicalRegisterSubCategory extends StatefulWidget {
  const ChemicalRegisterSubCategory({
    Key? key,
    required this.title,
    required this.id,
  }) : super(key: key);

  final String title;
  final String id;

  @override
  State<ChemicalRegisterSubCategory> createState() =>
      _ChemicalRegisterSubCategoryState();
}

class _ChemicalRegisterSubCategoryState
    extends State<ChemicalRegisterSubCategory> {
  int _page = 1;
  final int _size = 1;
  bool _hasNextPage = true;
  bool _isVisible = true;

  bool _chemicalsLoading = false;
  bool _isLoadMoreRunning = false;

  late ChemicalRegisterApi chemicalRegisterApi;
  late ScrollController _scrollController;

  List<ChemicalModel> chemicalSubtances = [];
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_CHEMICAL_REGISTER_SUBCATEGORY_LIST_SCREEN);
    chemicalRegisterApi = ChemicalRegisterApi(context);
    _firstLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    super.dispose();
  }

  void _firstLoad() async {
    setState(() {
      _chemicalsLoading = true;
    });

    List<ChemicalModel> chemicalsRes = [];
    await getChemicals().then((value) {
      chemicalsRes = value;
    }, onError: (e) => Utils.handleError(context, e));

    setState(() {
      chemicalSubtances = chemicalsRes;
      _chemicalsLoading = false;
    });
  }

  void resetState() {
    setState(() {
      _page = 1;
      _hasNextPage = true;
      _isVisible = true;
      _isLoadMoreRunning = false;
      _chemicalsLoading = true;
      chemicalSubtances = [];
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _chemicalsLoading == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page++;

      List<ChemicalModel> chemicalsRes = [];
      await getChemicals().then(
        (value) => chemicalsRes = value,
        onError: (e) => Utils.handleError(context, e),
      );
      if (chemicalsRes.isNotEmpty) {
        setState(() {
          chemicalSubtances.addAll(chemicalsRes);
        });
      }

      if (chemicalsRes.length < _size) {
        setState(() {
          _hasNextPage = false;
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _isVisible = false;
          });
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future<List<ChemicalModel>> getChemicals() async {
    ResultListChemicalModel res = await chemicalRegisterApi.getChemicals(
      _page,
      _size,
      widget.id,
    );
    return res.result;
  }

  Future<void> onRefresh() async {
    resetState();
    List<ChemicalModel> chemicalsRes = [];
    await getChemicals().then((value) {
      chemicalsRes = value;
    }, onError: (e) => Utils.handleError(context, e));

    setState(() {
      chemicalSubtances = chemicalsRes;
      _chemicalsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
      ),
      body: _chemicalsLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomPageTitle(
                    title: widget.title.toUpperCase(),
                    margin: const EdgeInsets.only(
                      bottom: 30,
                      left: 16,
                      right: 16,
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: onRefresh,
                      child: chemicalSubtances.isEmpty
                          ? Center(
                              child: Text(
                                Utils.getTranslated(
                                    context,
                                    AppPageConstants.CHEMICALREGISTER,
                                    'noRecord'),
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: chemicalSubtances.length +
                                  1, // +1 for loading widget below
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index < chemicalSubtances.length) {
                                  return CustomListTile(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 20,
                                    ),
                                    title: chemicalSubtances[index].name,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.chemicalDetailRoute,
                                        arguments: chemicalSubtances[index],
                                      );
                                    },
                                  );
                                } else {
                                  if (_isLoadMoreRunning == true) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 40),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  // When nothing else to load
                                  if (_hasNextPage == false) {
                                    return AnimatedOpacity(
                                      opacity: _isVisible ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 30, bottom: 40),
                                        child: Center(
                                          child: Text(
                                            Utils.getTranslated(
                                              context,
                                              AppPageConstants.CHEMICALREGISTER,
                                              'noMoreItem',
                                            ),
                                            style:
                                                AppFont.helveticaNeueBold(14),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
