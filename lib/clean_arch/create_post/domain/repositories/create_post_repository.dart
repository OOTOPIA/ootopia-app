import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';

abstract class CreatePostRepository {
  Future<Either<Failure, bool>> createPost({required CreatePostEntity post});
  Future<Either<Failure, List<InterestsTagsEntity>>> getTags();
  Future<Either<Failure, List<UsersEntity>>> getUsers({
    required String fullName,
    required int page,
    String? excludedIds,
  });
}
