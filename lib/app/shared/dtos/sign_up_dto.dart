import 'dart:convert';

class SignUpDTO {
  SignUpDTO({
    required this.displayName,
    required this.email,
    required this.password,
  });

  final String displayName;
  final String email;
  final String password;

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'password': password,
    };
  }

  factory SignUpDTO.fromMap(Map<String, dynamic> map) {
    return SignUpDTO(
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpDTO.fromJson(String source) =>
      SignUpDTO.fromMap(json.decode(source));
}
