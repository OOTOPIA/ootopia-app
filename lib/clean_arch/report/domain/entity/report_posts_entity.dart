class ReportPostsEntity {
  final bool visualizerPostUser;
  final String denouncedId;
  final String? postId;
  final String reason;
  ReportPostsEntity({
    required this.denouncedId,
    required this.visualizerPostUser,
    this.postId,
    required this.reason,
  });
}
