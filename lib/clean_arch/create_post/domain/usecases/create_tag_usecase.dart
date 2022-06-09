import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';

class CreateTagUsecase {
  final CreatePostRepository _createPostRepository;
  CreateTagUsecase({required CreatePostRepository createPostRepository})
      : _createPostRepository = createPostRepository;

  Future<Either<Failure, InterestsTagsEntity>> call(
      {required String name}) async {
    return await _createPostRepository.createTag(name: name);
  }
}
