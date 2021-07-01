class CommentCreate {
  String postId;
  String text;

  CommentCreate({required this.postId, required this.text});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['text'] = this.text;
    return data;
  }
}
