import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_category_model.dart';
import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';

class ChemicalSubCategoryModel {
  final String id;
  final String name;
  final BlobFileModel image;
  final ChemicalCategoryModel category;

  ChemicalSubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image.toJson(),
      'category': category.toJson(),
    };
  }

  factory ChemicalSubCategoryModel.fromJson(Map<String, dynamic> map) {
    return ChemicalSubCategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: BlobFileModel.fromJson(map['image']),
      category: ChemicalCategoryModel.fromJson(map['category']),
    );
  }
}
