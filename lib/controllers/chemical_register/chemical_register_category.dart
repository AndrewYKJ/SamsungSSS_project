import 'dart:async';

import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/app_font.dart';
import 'package:samsung_sss_flutter/const/app_page_constant.dart';
import 'package:samsung_sss_flutter/const/utils.dart';
import 'package:samsung_sss_flutter/dio/api/chemical_register_api.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_category_model.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_subcategory_model.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/result_list_chemical_subcategory_model.dart';
import 'package:samsung_sss_flutter/models/page_argument/chemical_subcategory_argument.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:samsung_sss_flutter/widgets/custom_app_bar.dart';
import 'package:samsung_sss_flutter/widgets/custom_list_tile.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';

class ChemicalRegisterCategory extends StatefulWidget {
  const ChemicalRegisterCategory({
    Key? key,
  }) : super(key: key);

  @override
  State<ChemicalRegisterCategory> createState() =>
      _ChemicalRegisterCategoryState();
}

class _ChemicalRegisterCategoryState extends State<ChemicalRegisterCategory> {
  int selectedCategoryIndex = 0;
  int _page = 1;
  final int _size = 20;
  bool _hasNextPage = true;
  bool _isVisible = true;

  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  bool _subCategoriesLoading = false;

  late ChemicalRegisterApi chemicalRegisterApi;
  late ScrollController _scrollController;

  List<ChemicalCategoryModel> categories = [];
  List<ChemicalSubCategoryModel> subCategories = [];

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_CHEMICAL_REGISTER_CATEGORY_LIST_SCREEN);
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
      _isFirstLoadRunning = true;
    });

    await chemicalRegisterApi.getCategories().then(
      (value) async {
        // let getSubCategories get the latest copy of categories
        categories = value;
        await getSubCategories().then(
          (value) => subCategories = value,
          onError: (e) => Utils.handleError(context, e),
        );
      },
      onError: (e) => Utils.handleError(context, e),
    ).whenComplete(() {
      setState(() {
        _isFirstLoadRunning = false;
      });
    });
  }

  void resetState() {
    setState(() {
      _page = 1;
      _hasNextPage = true;
      _isVisible = true;
      _isLoadMoreRunning = false;
      _subCategoriesLoading = false;
      subCategories = [];
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page++;

      List<ChemicalSubCategoryModel> subCategoryRes = [];
      await getSubCategories().then(
        (value) => subCategoryRes = value,
        onError: (e) => Utils.handleError(context, e),
      );
      if (subCategoryRes.isNotEmpty) {
        setState(() {
          subCategories.addAll(subCategoryRes);
        });
      }

      if (subCategoryRes.length < _size) {
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

  Future<List<ChemicalSubCategoryModel>> getSubCategories() async {
    ResultListSubCategoryModel res = await chemicalRegisterApi.getSubCategories(
      _page,
      _size,
      categories[selectedCategoryIndex].id,
    );
    return res.result;
  }

  Future<void> loadSelectedCategory() async {
    resetState();
    setState(() {
      _subCategoriesLoading = true;
    });
    List<ChemicalSubCategoryModel> items = [];
    await getSubCategories().then(
      (value) {
        items = value;
      },
      onError: (e) => Utils.handleError(context, e),
    );

    setState(() {
      subCategories = items;
      _subCategoriesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
      ),
      body: _isFirstLoadRunning
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomPageTitle(
                          title: Utils.getTranslated(
                            context,
                            AppPageConstants.CHEMICALREGISTER,
                            'chemicalRegisterTitle',
                          ).toUpperCase(),
                          margin: const EdgeInsets.only(bottom: 30),
                        ),
                        subCategoryChoiceList(),
                      ],
                    ),
                  ),
                  subCategoryList(subCategories),
                ],
              ),
            ),
    );
  }

  Widget subCategoryChoiceList() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ChoiceChip(
                labelStyle: AppFont.helveticaNeueBold(
                  16,
                  color: AppColor.wordingColorBlack,
                ),
                backgroundColor: Colors.transparent,
                side: selectedCategoryIndex == index
                    ? const BorderSide(
                        color: AppColor.choiceChipBorderColor,
                      )
                    : BorderSide.none,
                shape: const StadiumBorder(side: BorderSide(width: 1)),
                label: Text(categories[index].name),
                selected: selectedCategoryIndex == index,
                onSelected: (selected) {
                  if (selectedCategoryIndex != index) {
                    setState(() {
                      selectedCategoryIndex = selected ? index : -1;
                    });
                    loadSelectedCategory();
                  }
                },
                selectedColor: AppColor.choiceChipColor,
                showCheckmark: false,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget subCategoryList(List<ChemicalSubCategoryModel> items) {
    return Expanded(
      child: _subCategoriesLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadSelectedCategory,
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        Utils.getTranslated(context,
                            AppPageConstants.CHEMICALREGISTER, 'noRecord'),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          items.length + 1, // +1 for loading widget below
                      itemBuilder: (context, index) {
                        if (index < items.length) {
                          return CustomListTile(
                            fontSize: 16,
                            isNetworkImage: true,
                            imagePath: items[index].image.url,
                            title: items[index].name,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(10),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.chemicalRegisterSubCategoryListRoute,
                                arguments: ChemicalSubCategoryArguments(
                                  id: items[index].id,
                                  name: items[index].name,
                                ),
                              );
                            },
                          );
                        } else {
                          if (_isLoadMoreRunning == true) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 40),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          // When nothing else to load
                          if (_hasNextPage == false) {
                            return AnimatedOpacity(
                              opacity: _isVisible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 40),
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
            ),
    );
  }
}
