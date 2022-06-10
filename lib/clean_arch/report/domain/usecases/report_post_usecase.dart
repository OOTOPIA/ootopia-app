import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/report/domain/entity/report_posts_entity.dart';
import 'package:ootopia_app/clean_arch/report/domain/repositories/reports_posts_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReportPostUseCase {
  final ReportPostsRepository _reportPostRepository;

  ReportPostUseCase({required ReportPostsRepository reportPostRepository})
      : _reportPostRepository = reportPostRepository;

  Future<Either<Failure, bool>> call(
      ReportPostsEntity reportPostsEntity) async {
    return _reportPostRepository.reportPost(
        reportPostEntity: reportPostsEntity);
  }
}
