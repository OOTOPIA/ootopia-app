import 'package:ootopia_app/clean_arch/core/constants/endpoints.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/dio_client.dart';
import 'package:ootopia_app/clean_arch/report/data/models/report_posts_model.dart';

abstract class ReportRemoteDataSource {
  Future<bool> sendReportPost(ReportPostsModel reportPostsModel);
}

class ReportRemoteDataSourceImpl extends ReportRemoteDataSource {
  final DioClient _dioClient;

  ReportRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;
  @override
  Future<bool> sendReportPost(ReportPostsModel reportPostsModel) async {
    try {
      var response = await _dioClient.post(
        Endpoints.reportPosts,
        data: reportPostsModel.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
