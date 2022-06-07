import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';

class CreatePostRepositoryImpl extends CreatePostRepository {
  final CreatePostRemoteDatasource _createPostRemoteDatasource;
  CreatePostRepositoryImpl(
      {required CreatePostRemoteDatasource createPostRemoteDatasource})
      : _createPostRemoteDatasource = createPostRemoteDatasource;

  @override
  Future<Either<Failure, bool>> createPost(
      {required CreatePostEntity post}) async {
    try {
      var createPostModel = CreatePostModel.fromEntity(post);
      var response = await _createPostRemoteDatasource.createPost(
        createPostModel: createPostModel,
      );
      if (response) {
        return Right(response);
      }
      return Left(Failure(message: ''));
    } catch (e) {
      return Left(Failure(message: ''));
    }
  }

  @override
  Future<Either<Failure, List<InterestsTagsEntity>>> getTags(
      {required String tags, required int page}) async {
    try {
      String currenLocalization = Platform.localeName.substring(0, 2);
      var response = await _createPostRemoteDatasource.getTags(
        language: currenLocalization,
        tags: tags,
        page: page,
      );
      return Right(response);
    } catch (e) {
      return Left(Failure(message: ''));
    }
  }

  @override
  Future<Either<Failure, List<UsersEntity>>> getUsers({
    required String fullName,
    required int page,
    String? excludedIds,
  }) async {
    try {
      var response = await _createPostRemoteDatasource.getUsers(
        page: page,
        fullname: fullName,
        excludedIds: excludedIds,
      );
      return Right(response);
    } catch (e) {
      return Left(Failure(message: ''));
    }
  }

  @override
  Future<Either<Failure, bool>> createTag({required String name}) async {
    try {
      var response = await _createPostRemoteDatasource.createTag(name: name);
      return Right(response);
    } catch (e) {
      return Left(Failure(message: ''));
    }
  }
}
