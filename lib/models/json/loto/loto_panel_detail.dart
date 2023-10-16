import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';

class LotoPanelDetailModel {
  String? id;
  String? name;
  String? status;
  List<BlobFileModel>? images;
  List<SwitchList>? switchList;

  LotoPanelDetailModel({
    this.id,
    this.name,
    this.status,
    this.images,
    this.switchList,
  });

  factory LotoPanelDetailModel.fromJson(Map<String, dynamic> json) =>
      LotoPanelDetailModel(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        images: json["images"] == null
            ? []
            : List<BlobFileModel>.from(
                json["images"]!.map(
                  (x) => BlobFileModel.fromJson(x),
                ),
              ),
        switchList: json["switchList"] == null
            ? []
            : List<SwitchList>.from(
                json["switchList"]!.map((x) => SwitchList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "images": images,
        "switchList": switchList == null
            ? []
            : List<dynamic>.from(switchList!.map((x) => x.toJson())),
      };
}

class SwitchList {
  String? id;
  String? name;
  String? status;
  dynamic dateIsolate;
  String? switchNo;
  String? unitNo;
  String? service;
  String? feederTag;
  String? rating;
  String? personInCharge;
  BlobFileModel? image;
  String? edicno;

  SwitchList({
    this.id,
    this.name,
    this.status,
    this.dateIsolate,
    this.switchNo,
    this.unitNo,
    this.service,
    this.feederTag,
    this.rating,
    this.personInCharge,
    this.image,
    this.edicno,
  });

  factory SwitchList.fromJson(Map<String, dynamic> json) => SwitchList(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        dateIsolate: json["dateIsolate"],
        switchNo: json["switchNo"],
        unitNo: json["unitNo"],
        service: json["service"],
        feederTag: json["feederTag"],
        rating: json["rating"],
        personInCharge: json["personInCharge"],
        image: json["image"] == null
            ? null
            : BlobFileModel.fromJson(json["image"]),
        edicno: json["edicno"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "dateIsolate": dateIsolate,
        "switchNo": switchNo,
        "unitNo": unitNo,
        "service": service,
        "feederTag": feederTag,
        "rating": rating,
        "personInCharge": personInCharge,
        "image": image?.toJson(),
        "edicno": edicno,
      };
}
