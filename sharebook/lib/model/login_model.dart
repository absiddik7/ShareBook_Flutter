import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.status,
    this.user,
    this.authorisation,
  });

  String? status;
  User? user;
  Authorisation? authorisation;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        user: User.fromJson(json["user"]),
        authorisation: Authorisation.fromJson(json["authorisation"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user": user!.toJson(),
        "authorisation": authorisation!.toJson(),
      };
}

class Authorisation {
  Authorisation({
    this.token,
    this.type,
  });

  String? token;
  String? type;

  factory Authorisation.fromJson(Map<String, dynamic> json) => Authorisation(
        token: json["token"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "type": type,
      };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
