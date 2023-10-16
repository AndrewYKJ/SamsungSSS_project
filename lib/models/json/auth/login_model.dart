class AuthModel {
  String? id;
  String? username;
  String? accessToken;
  String? refreshToken;
  String? code;
  String? message;

  AuthModel({
    this.id,
    this.username,
    this.accessToken,
    this.refreshToken,
    this.code,
    this.message,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        id: json["id"],
        username: json["username"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "code": code,
        "message": message,
      };
}
