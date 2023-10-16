import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';

class ChemicalModel {
  final String id;
  final String name;
  final String symbol;
  final BlobFileModel? image;
  final BlobFileModel? sdsSummary;
  final BlobFileModel? sds;

  ChemicalModel({
    required this.id,
    required this.name,
    required this.symbol,
    this.image,
    this.sdsSummary,
    this.sds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'image': image?.toJson(),
      'sdsSummary': sdsSummary?.toJson(),
      'sds': sds?.toJson(),
    };
  }

  factory ChemicalModel.fromJson(Map<String, dynamic> map) {
    return ChemicalModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      image: map['image'] != null ? BlobFileModel.fromJson(map['image']) : null,
      sdsSummary: map['sdsSummary'] != null
          ? BlobFileModel.fromJson(map['sdsSummary'])
          : null,
      sds: map['sds'] != null ? BlobFileModel.fromJson(map['sds']) : null,
    );
  }
}
