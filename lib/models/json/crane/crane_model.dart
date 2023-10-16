import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';

class Crane {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String status;
  final String subContractorName;
  final String location;
  final String liftingSupervisor;
  final num lat;
  final num lng;
  final BlobFileModel? liftingPlan;
  final List<BlobFileModel>? images;

  Crane(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.status,
    this.subContractorName,
    this.location,
    this.liftingSupervisor,
    this.lat,
    this.lng,
    this.liftingPlan,
    this.images,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'name': name,
      'status': status,
      'subContractorName': subContractorName,
      'location': location,
      'liftingSupervisor': liftingSupervisor,
      'lat': lat,
      'lng': lng,
      'liftingPlan': liftingPlan?.toJson(),
      'images': images?.map((x) => x.toJson()).toList(),
    };
  }

  factory Crane.fromJson(Map<String, dynamic> map) {
    return Crane(
      map['id'] ?? '',
      DateTime.parse(map['createdAt']),
      DateTime.parse(map['updatedAt']),
      map['name'] ?? '',
      map['status'] ?? '',
      map['subContractorName'] ?? '',
      map['location'] ?? '',
      map['liftingSupervisor'] ?? '',
      map['lat'] ?? 0,
      map['lng'] ?? 0,
      map['liftingPlan'] != null
          ? BlobFileModel.fromJson(map['liftingPlan'])
          : null,
      map['images'] != null
          ? List<BlobFileModel>.from(
              map['images']?.map((x) => BlobFileModel.fromJson(x)))
          : null,
    );
  }
}
