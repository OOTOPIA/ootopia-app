import 'package:get_it/get_it.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/repositories/create_post_repository.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_post_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_tag_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/get_interest_tags_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/search_user_by_name_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/send_medias_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/interesting_tags_store.dart';

class CreatePostDi {
  static Future<void> injectionDI() async {
    final getIt = GetIt.I;

    getIt.registerSingleton<CreatePostRemoteDatasource>(
        CreatePostRemoteDatasourceImpl(httpClient: getIt.get()));

    getIt.registerSingleton<CreatePostRepository>(
        CreatePostRepositoryImpl(createPostRemoteDatasource: getIt.get()));

    getIt.registerSingleton<CreatePostUsecase>(
        CreatePostUsecase(createPostRepository: getIt.get()));

    getIt.registerSingleton<GetInterestTagsUsecase>(
        GetInterestTagsUsecase(createPostRepository: getIt.get()));

    getIt.registerSingleton<SearchUserByNameUsecase>(
        SearchUserByNameUsecase(createPostRepository: getIt.get()));

    getIt.registerSingleton<CreateTagUsecase>(
        CreateTagUsecase(createPostRepository: getIt.get()));

    getIt.registerSingleton<SendMediasUsecase>(
        SendMediasUsecase(createPostRepository: getIt.get()));

    getIt.registerSingleton(StoreCreatePosts(
      searchUser: getIt.get(),
      createPostUsecase: getIt.get(),
      sendMediasUsecase: getIt.get(),
    ));

    getIt.registerSingleton(InterestingTagsStore(
      getTags: getIt.get(),
      createTags: getIt.get(),
    ));
  }
}
