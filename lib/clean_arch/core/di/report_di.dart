import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/http_client.dart';
import 'package:ootopia_app/clean_arch/report/data/datasource/remote_data_source.dart';
import 'package:ootopia_app/clean_arch/report/data/repositories/report_posts_repository_impl.dart';
import 'package:ootopia_app/clean_arch/report/domain/repositories/reports_posts_repository.dart';
import 'package:ootopia_app/clean_arch/report/domain/usecases/report_post_usecase.dart';
import 'package:ootopia_app/clean_arch/report/presentation/stores/store_report_post.dart';

class ReportDi {
  static Future<void> injectionDI() async {
    final getIt = GetIt.I;
    getIt.registerSingleton<Dio>(Dio());

    getIt.registerSingleton<HttpClient>(HttpClient(dio: getIt.get()));

    getIt.registerSingleton<ReportRemoteDataSource>(
        ReportRemoteDataSourceImpl(dioClient: getIt.get()));

    getIt.registerSingleton<ReportPostsRepository>(
        ReportPostRepositoryImpl(remoteDataSource: getIt.get()));

    getIt.registerSingleton<ReportPostUseCase>(
        ReportPostUseCase(reportPostRepository: getIt.get()));

    getIt.registerSingleton<StoreReportPost>(
        StoreReportPost(reportPost: getIt.get()));
  }
}
