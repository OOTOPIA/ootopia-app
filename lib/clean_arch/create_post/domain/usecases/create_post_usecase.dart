import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';

class CreatePostUsecase {
  final CreatePostRepository _createPostRepository;
  CreatePostUsecase({required CreatePostRepository createPostRepository})
      : _createPostRepository = createPostRepository;

  Future<Either<Failure, bool>> call(CreatePostEntity createPostEntity) async {
    return _createPostRepository.createPost(post: createPostEntity);
  }
}
