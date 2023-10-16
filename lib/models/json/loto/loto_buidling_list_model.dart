// To parse this JSON data, do
//
//     final lotoBuildingDetails = lotoBuildingDetailsFromJson(jsonString);

import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';

class LotoBuidlingList {
  List<LotoBuildingDetails>? buildingList;

  LotoBuidlingList({this.buildingList});

  factory LotoBuidlingList.fromJson(Map<String, dynamic> json) =>
      LotoBuidlingList(
        buildingList: json["data"] != null
            ? List<LotoBuildingDetails>.from(
                json["data"]!.map((x) => LotoBuildingDetails.fromJson(x)))
            : [],
      );
}

class LotoBuildingDetails {
  String? id;
  String? name;
  BlobFileModel? image;
  int? rowUnit;
  int? colUnit;
  int? totalUnit;
  int? totalActive;
  int? totalInactive;

  LotoBuildingDetails({
    this.id,
    this.name,
    this.image,
    this.rowUnit,
    this.colUnit,
    this.totalUnit,
    this.totalActive,
    this.totalInactive,
  });

  factory LotoBuildingDetails.fromJson(Map<String, dynamic> json) =>
      LotoBuildingDetails(
        id: json["id"],
        name: json["name"],
        image: json['image'] != null
            ? BlobFileModel.fromJson(json['image'])
            : null,
        rowUnit: json["rowUnit"],
        colUnit: json["colUnit"],
        totalUnit: json["totalUnit"],
        totalActive: json["totalActive"],
        totalInactive: json["totalInactive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image?.toJson(),
        "rowUnit": rowUnit,
        "colUnit": colUnit,
        "totalUnit": totalUnit,
        "totalActive": totalActive,
        "totalInactive": totalInactive,
      };
}
