import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/report/data/datasource/remote_data_source.dart';
import 'package:ootopia_app/clean_arch/report/data/models/report_posts_model.dart';
import 'package:ootopia_app/clean_arch/report/domain/entity/report_posts_entity.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/report/domain/repositories/reports_posts_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ReportPostsRepository)
class ReportPostRepositoryImpl extends ReportPostsRepository {
  final ReportRemoteDataSource _remoteDataSource;
  ReportPostRepositoryImpl({required ReportRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, bool>> reportPost(
      {required ReportPostsEntity reportPostEntity}) async {
    var response = await _remoteDataSource
        .sendReportPost(ReportPostsModel.fromEntity(reportPostEntity));
    if (response) {
      return Right(response);
    }
    return Left(Failure(message: 'Something went Wrong'));
  }
}
