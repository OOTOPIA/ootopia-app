import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
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
      var response = await _createPostRemoteDatasource.createPost(
        createPostModel: CreatePostModel.fromEntity(post),
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
  Future<Either<Failure, List<InterestsTagsEntity>>> getTags() async {
    try {
      String currenLocalization = Platform.localeName.substring(0, 2);
      var response = await _createPostRemoteDatasource.getTags(
        language: currenLocalization,
      );
      return Right(response);
    } catch (e) {
      return Left(Failure(message: ''));
    }
  }
}
