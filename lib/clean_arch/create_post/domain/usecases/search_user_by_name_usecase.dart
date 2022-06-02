import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';

class SearchUserByNameUsecase {
  final CreatePostRepository _createPostRepository;
  SearchUserByNameUsecase({required CreatePostRepository createPostRepository})
      : _createPostRepository = createPostRepository;
  Future<Either<Failure, List<UsersEntity>>> call({
    required String fullName,
    required int page,
    String? excludedIds,
  }) async {
    return _createPostRepository.getUsers(
      fullName: fullName,
      page: page,
      excludedIds: excludedIds,
    );
  }
}
