import 'package:ootopia_app/clean_arch/report/domain/entity/report_posts_entity.dart';
import 'package:ootopia_app/clean_arch/report/domain/entity/state_report.dart';

class ReportPostsModel extends ReportPostsEntity {
  ReportPostsModel({
    required String idUser,
    required StateReport stateReport,
    String? text,
  }) : super(
          idUser: idUser,
          stateReport: stateReport,
          text: text,
        );

  factory ReportPostsModel.fromEntity(ReportPostsEntity reportPostsEntity) {
    return ReportPostsModel(
      idUser: reportPostsEntity.idUser,
      stateReport: reportPostsEntity.stateReport,
      text: reportPostsEntity.text,
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
