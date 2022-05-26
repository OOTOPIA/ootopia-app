import 'package:ootopia_app/clean_arch/core/constants/endpoints.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/dio_client.dart';
import 'package:ootopia_app/clean_arch/report/data/models/report_posts_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';

abstract class ReportRemoteDataSource {
  Future<bool> sendReportPost(ReportPostsModel reportPostsModel);
}

class ReportRemoteDataSourceImpl extends ReportRemoteDataSource {
  final DioClient _dioClient;

  ReportRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;
  @override
  Future<bool> sendReportPost(ReportPostsModel reportPostsModel) async {
    print(reportPostsModel.toJson());
    try {
      var response = await ApiClient.api().post(
        Endpoints.reportPosts,
        data: reportPostsModel.toJson(),
      );
      print(response);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
