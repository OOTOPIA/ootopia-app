import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/report/domain/entity/report_posts_entity.dart';

abstract class ReportPostsRepository {
  Future<Either<Failure, bool>> reportPost(
      {required ReportPostsEntity reportPostEntity});
}
