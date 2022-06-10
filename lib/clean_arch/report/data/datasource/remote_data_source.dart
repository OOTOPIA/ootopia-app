import 'package:ootopia_app/clean_arch/core/constants/endpoints.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/http_client.dart';
import 'package:ootopia_app/clean_arch/report/data/models/report_posts_model.dart';
import 'package:injectable/injectable.dart';

abstract class ReportRemoteDataSource {
  Future<bool> sendReportPost(ReportPostsModel reportPostsModel);
}

@Injectable(as: ReportRemoteDataSource)
class ReportRemoteDataSourceImpl extends ReportRemoteDataSource {
  final HttpClient _dioClient;

  ReportRemoteDataSourceImpl({required HttpClient dioClient})
      : _dioClient = dioClient;
  @override
  Future<bool> sendReportPost(ReportPostsModel reportPostsModel) async {
    try {
      var response = await _dioClient.post(
        Endpoints.reportPosts,
        data: reportPostsModel.toJson(),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
