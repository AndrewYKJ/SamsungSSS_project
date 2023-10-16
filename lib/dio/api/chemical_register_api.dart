import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/dio/dio_repo.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_category_model.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_model.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_subcategory_model.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/result_list_chemical_model.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/result_list_chemical_subcategory_model.dart';

class ChemicalRegisterApi extends DioRepo {
  ChemicalRegisterApi(BuildContext context) {
    dioContext = context;
  }

  Future<List<ChemicalCategoryModel>> getCategories() async {
    try {
      Response response = await dio.get('v1/cms/chemical/category');
      final categoryList = (response.data as List).map((categoryData) {
        return ChemicalCategoryModel.fromJson(categoryData);
      });
      return categoryList.toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ChemicalCategoryModel> getCategoryDetail(String id) async {
    try {
      Response response =
          await dio.get('v1/cms/chemical/category', data: {'id': id});
      return ChemicalCategoryModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResultListSubCategoryModel> getSubCategories(
      int page, int size, String categoryId,
      {String keyword = ""}) async {
    final Map<String, dynamic> params = {
      'page': page,
      'size': size,
      'categoryId': categoryId,
      'keyword': keyword,
    };
    try {
      Response response = await dio.get(
        'v1/cms/chemical/sub_category',
        queryParameters: params,
      );
      return ResultListSubCategoryModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ChemicalSubCategoryModel> getSubCategory(String id) async {
    try {
      Response response = await dio.get('v1/cms/chemical/subcategory/$id');
      return ChemicalSubCategoryModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ChemicalModel> getChemical(String id) async {
    try {
      Response response = await dio.get('v1/cms/chemical/$id');
      return ChemicalModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResultListChemicalModel> getChemicals(
      int page, int size, String subCategoryId,
      {String keyword = ""}) async {
    final Map<String, dynamic> params = {
      'page': page,
      'size': size,
      'subCategoryId': subCategoryId,
      'keyword': keyword,
    };
    try {
      Response response = await dio.get(
        'v1/cms/chemical',
        queryParameters: params,
      );
      return ResultListChemicalModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
