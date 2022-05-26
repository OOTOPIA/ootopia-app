import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/clean_arch/report/domain/entity/report_posts_entity.dart';

part 'report_posts_model.g.dart';

@JsonSerializable()
class ReportPostsModel extends ReportPostsEntity {
  ReportPostsModel({
    required bool visualizerPostUser,
    required String denouncedId,
    String? postId,
    required String reason,
  }) : super(
          denouncedId: denouncedId,
          postId: postId,
          visualizerPostUser: visualizerPostUser,
          reason: reason,
        );

  factory ReportPostsModel.fromEntity(ReportPostsEntity reportPostsEntity) {
    return ReportPostsModel(
      denouncedId: reportPostsEntity.denouncedId,
      postId: reportPostsEntity.postId,
      visualizerPostUser: reportPostsEntity.visualizerPostUser,
      reason: reportPostsEntity.reason,
    );
  }

  Map<String, dynamic> toJson() {
    return _$ReportPostsModelToJson(this);
  }
}
