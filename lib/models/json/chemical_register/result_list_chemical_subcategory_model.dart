import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_subcategory_model.dart';

class ResultListSubCategoryModel {
  int total;
  List<ChemicalSubCategoryModel> result;

  ResultListSubCategoryModel({
    required this.total,
    required this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'result': result.map((x) => x.toJson()).toList(),
    };
  }

  factory ResultListSubCategoryModel.fromJson(Map<String, dynamic> map) {
    return ResultListSubCategoryModel(
      total: map['total'] ?? 0,
      result: List<ChemicalSubCategoryModel>.from(
          map['result']?.map((x) => ChemicalSubCategoryModel.fromJson(x))),
    );
  }
}
