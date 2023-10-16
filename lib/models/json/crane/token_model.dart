class Token {
  final String token;

  Token(this.token);

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

  factory Token.fromJson(Map<String, dynamic> map) {
    return Token(
      map['token'] ?? '',
    );
  }
}
