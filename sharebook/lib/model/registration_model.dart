// To parse this JSON data, do
//
//     final registrationModel = registrationModelFromJson(jsonString);

import 'dart:convert';

RegistrationModel registrationModelFromJson(String str) => RegistrationModel.fromJson(json.decode(str));

String registrationModelToJson(RegistrationModel data) => json.encode(data.toJson());

class RegistrationModel {
    RegistrationModel({
        this.status,
        this.message,
        this.user,
        this.authorisation,
    });

    String? status;
    String? message;
    User? user;
    Authorisation? authorisation;

    factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
        status: json["status"],
        message: json["message"],
        user: User.fromJson(json["user"]),
        authorisation: Authorisation.fromJson(json["authorisation"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
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
        this.name,
        this.email,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    String? name;
    String? email;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "id": id,
    };
}
