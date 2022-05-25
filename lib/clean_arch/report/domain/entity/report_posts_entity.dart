import 'package:ootopia_app/clean_arch/report/domain/entity/state_report.dart';

class ReportPostsEntity {
  final String idUser;
  final StateReport stateReport;
  final String? text;

  ReportPostsEntity({
    this.text,
    required this.idUser,
    required this.stateReport,
  });
}
