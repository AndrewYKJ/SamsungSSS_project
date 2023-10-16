import 'package:samsung_sss_flutter/models/json/blob_file/blob_file_model.dart';

class LotoPanelModel {
  int? total;
  List<Result>? result;

  LotoPanelModel({
    this.total,
    this.result,
  });

  factory LotoPanelModel.fromJson(Map<String, dynamic> json) => LotoPanelModel(
        total: json["total"],
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  String? id;
  String? name;
  String? status;
  List<BlobFileModel>? images;

  Result({
    this.id,
    this.name,
    this.status,
    this.images,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        images: json["images"] == null
            ? []
            : List<BlobFileModel>.from(
                json["images"]!.map((x) => BlobFileModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "images": images == null
            ? []
            : List<BlobFileModel>.from(images!.map((x) => x)),
      };
}
