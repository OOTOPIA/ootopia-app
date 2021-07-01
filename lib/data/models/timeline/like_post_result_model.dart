import 'package:equatable/equatable.dart';

class LikePostResult extends Equatable {
  int count;
  bool liked = false;

  LikePostResult({required this.count, required this.liked});

  factory LikePostResult.fromJson(Map<String, dynamic> parsedJson) {
    return LikePostResult(
        count: parsedJson['count'], liked: parsedJson['liked']);
  }

  @override
  List<Object> get props => [
        count,
        liked,
      ];
}
