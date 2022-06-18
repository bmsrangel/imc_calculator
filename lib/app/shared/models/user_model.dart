import 'dart:convert';

class UserModel {
  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.profileUrl,
  });

  final String id;
  final String displayName;
  final String email;
  final String? profileUrl;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'profileUrl': profileUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? profileUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}
