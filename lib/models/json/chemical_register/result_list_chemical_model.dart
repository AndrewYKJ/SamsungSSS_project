import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_model.dart';

class ResultListChemicalModel {
  int total;
  List<ChemicalModel> result;

  ResultListChemicalModel({
    required this.total,
    required this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'result': result.map((chemical) => chemical.toJson()).toList(),
    };
  }

  factory ResultListChemicalModel.fromJson(Map<String, dynamic> map) {
    return ResultListChemicalModel(
      total: map['total'] ?? 0,
      result: List<ChemicalModel>.from(
          map['result']?.map((chemical) => ChemicalModel.fromJson(chemical))),
    );
  }
}
