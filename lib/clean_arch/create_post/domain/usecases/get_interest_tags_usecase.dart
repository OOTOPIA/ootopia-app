import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';

class GetInterestTagsUsecase {
  final CreatePostRepository _createPostRepository;
  GetInterestTagsUsecase({required CreatePostRepository createPostRepository})
      : _createPostRepository = createPostRepository;

  Future<Either<Failure, List<InterestsTagsEntity>>> call(
      {required String tags}) async {
    return _createPostRepository.getTags(tags: tags);
  }
}
