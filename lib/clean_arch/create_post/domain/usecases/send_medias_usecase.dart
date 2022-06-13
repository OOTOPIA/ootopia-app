import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendMediasUsecase {
  final CreatePostRepository _createPostRepository;
  SendMediasUsecase({required CreatePostRepository createPostRepository})
      : _createPostRepository = createPostRepository;

  Future<Either<Failure, String>> call(
      {required String type, required File file}) async {
    return await _createPostRepository.sendMedia(type, file);
  }
}
