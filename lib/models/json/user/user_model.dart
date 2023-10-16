class UserModel {
  String? id;
  String? username;
  String? name;
  String? status;
  String? mobileNo;
  String? dob;
  String? department;
  String? designation;
  String? company;
  String? lastLoginAt;
  String? accountBlockedUntil;
  String? code;
  String? message;

  UserModel({
    this.id,
    this.username,
    this.name,
    this.status,
    this.mobileNo,
    this.dob,
    this.department,
    this.designation,
    this.company,
    this.lastLoginAt,
    this.accountBlockedUntil,
    this.code,
    this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        status: json["status"],
        mobileNo: json["mobileNo"],
        dob: json["dob"],
        department: json["department"],
        designation: json["designation"],
        company: json["company"],
        lastLoginAt: json["lastLoginAt"],
        accountBlockedUntil: json["accountBlockedUntil"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "dob": dob,
        "mobileNo": mobileNo,
        "department": department,
        "designation": designation,
        "company": company,
      };
}
