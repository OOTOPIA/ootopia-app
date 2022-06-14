import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CreatePostRepository)
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
      return Left(Failure(message: 'It\'s not possible to create your post'));
    } catch (e) {
      return Left(Failure(message: 'It\'s not possible to create your post'));
    }
  }

  @override
  Future<Either<Failure, List<InterestsTagsEntity>>> getTags(
      {required String tags, required int page}) async {
    try {
      String currenLocalization = Platform.localeName;
      var response = await _createPostRemoteDatasource.getTags(
        language: currenLocalization,
        tags: tags,
        page: page,
      );
      return Right(response);
    } catch (e) {
      return Left(
          Failure(message: 'Something went wrong when try to get tags'));
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
      return Left(
          Failure(message: 'Something went wrong when try to get users'));
    }
  }

  @override
  Future<Either<Failure, InterestsTagsEntity>> createTag(
      {required String name}) async {
    try {
      String currenLocalization = Platform.localeName.replaceAll('_', '-');
      var response = await _createPostRemoteDatasource.createTag(
        name: name,
        language: currenLocalization,
      );
      return Right(response);
    } catch (e) {
      return Left(
          Failure(message: 'Something went wrong when try to create a tag'));
    }
  }

  @override
  Future<Either<Failure, String>> sendMedia(String type, File file) async {
    try {
      var response = await _createPostRemoteDatasource.sendMedia(type, file);
      return Right(response);
    } catch (e) {
      return Left(Failure(
          message: 'Something went wrong when try to send your medias'));
    }
  }
}
