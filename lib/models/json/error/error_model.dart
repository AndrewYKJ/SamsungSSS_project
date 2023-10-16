class ErrorModel {
  String code;
  String message;

  ErrorModel({required this.code, required this.message});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }

  factory ErrorModel.fromJson(Map<String, dynamic> map) {
    return ErrorModel(
      code: map['code'] ?? '',
      message: map['message'] ?? '',
    );
  }
}
