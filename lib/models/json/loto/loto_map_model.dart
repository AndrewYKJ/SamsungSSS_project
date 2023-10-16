class LotoMapModel {
  List<BuildingRow>? rows;

  LotoMapModel({
    this.rows,
  });

  factory LotoMapModel.fromJson(Map<String, dynamic> json) => LotoMapModel(
        rows: json["rows"] == null
            ? []
            : List<BuildingRow>.from(
                json["rows"]!.map((x) => BuildingRow.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class BuildingRow {
  int? rowNo;
  List<BuildingCol>? col;

  BuildingRow({
    this.rowNo,
    this.col,
  });

  factory BuildingRow.fromJson(Map<String, dynamic> json) => BuildingRow(
        rowNo: json["rowNo"],
        col: json["col"] == null
            ? []
            : List<BuildingCol>.from(
                json["col"]!.map((x) => BuildingCol.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rowNo": rowNo,
        "col":
            col == null ? [] : List<dynamic>.from(col!.map((x) => x.toJson())),
      };
}

class BuildingCol {
  int? colNo;
  String? type;
  String? status;
  String? panelId;

  BuildingCol({
    this.colNo,
    this.type,
    this.status,
    this.panelId,
  });

  factory BuildingCol.fromJson(Map<String, dynamic> json) => BuildingCol(
        colNo: json["colNo"],
        type: json["type"],
        status: json["status"],
        panelId: json["panelId"],
      );

  Map<String, dynamic> toJson() => {
        "colNo": colNo,
        "type": type,
        "status": status,
        "panelId": panelId,
      };
}
