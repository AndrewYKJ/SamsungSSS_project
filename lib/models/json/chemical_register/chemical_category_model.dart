class ChemicalCategoryModel {
  final String id;
  final String name;

  ChemicalCategoryModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ChemicalCategoryModel.fromJson(Map<String, dynamic> map) {
    return ChemicalCategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }
}
