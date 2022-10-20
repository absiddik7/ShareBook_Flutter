// To parse this JSON data, do
//
//     final blogModel = blogModelFromJson(jsonString);

import 'dart:convert';

// List<BlogModel> blogModelFromJson(String str) => List<BlogModel>.from(json.decode(str).map((x) => BlogModel.fromJson(x)));

// String blogModelToJson(List<BlogModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogModel {
  BlogModel({
    this.id,
    this.author,
    this.authorName,
    this.title,
    this.body,
    this.likes,
    this.createdAt,
    this.updatedAt,
    this.dislikes,
  });

  int? id;
  int? author;
  String? authorName;
  String? title;
  String? body;
  int? likes;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? dislikes;

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        id: json["id"],
        author: json["author"],
        authorName: json["author_name"],
        title: json["title"],
        body: json["body"],
        likes: json["likes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        dislikes: json["dislikes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "author_name": authorName,
        "title": title,
        "body": body,
        "likes": likes,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "dislikes": dislikes,
      };
}
