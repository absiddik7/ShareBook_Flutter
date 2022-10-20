import 'dart:convert';

// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

// String userModelToJson(UserModel data) => json.encode(data.toJson());

// class UserModel {
//     UserModel({
//         this.users,
//     });

//     List<User>? users;

//     factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//         users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "users": List<dynamic>.from(users!.map((x) => x.toJson())),
//     };
// }

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,

  });

  int? id;
  String? name;
  String? email;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
