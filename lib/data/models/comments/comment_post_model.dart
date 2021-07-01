import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  String id;
  String postId;
  String userId;
  String text;
  String? photoUrl;
  String? username;
  bool deleted = false;
  bool selected = false;
  DateTime? createdAt;
  DateTime? updatedAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    this.photoUrl,
    required this.username,
    required this.deleted,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      text: json['text'],
      photoUrl: json['photoUrl'],
      username: json['username'],
      deleted: (json['deleted'] == null ? false : json['deleted']),
      //createdAt: DateTime(json['createdAt']),
      //updatedAt: DateTime(json['updatedAt']),
    );
  }

  @override
  List<dynamic> get props => [
        id,
        postId,
        userId,
        text,
        photoUrl,
        username,
        deleted,
        selected,
        createdAt,
        updatedAt,
      ];
}
