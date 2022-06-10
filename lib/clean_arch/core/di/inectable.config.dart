// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../create_post/data/datasource/create_post_remote_datasource.dart'
    as _i6;
import '../../create_post/data/repositories/create_post_repository.dart' as _i8;
import '../../create_post/domain/repositories/create_post_repository.dart'
    as _i7;
import '../../create_post/domain/usecases/create_post_usecase.dart' as _i9;
import '../../create_post/domain/usecases/create_tag_usecase.dart' as _i10;
import '../../create_post/domain/usecases/get_interest_tags_usecase.dart'
    as _i11;
import '../../create_post/domain/usecases/search_user_by_name_usecase.dart'
    as _i15;
import '../../create_post/domain/usecases/send_medias_usecase.dart' as _i16;
import '../../create_post/presentation/stores/create_posts_stores.dart' as _i17;
import '../../create_post/presentation/stores/interesting_tags_store.dart'
    as _i12;
import '../../report/data/datasource/remote_data_source.dart' as _i5;
import '../../report/data/repositories/report_posts_repository_impl.dart'
    as _i14;
import '../../report/domain/repositories/reports_posts_repository.dart' as _i13;
import '../../report/domain/usecases/report_post_usecase.dart' as _i18;
import '../../report/presentation/stores/store_report_post.dart' as _i19;
import '../drivers/dio/http_client.dart' as _i4;
import '../drivers/third_parts/third_models.dart'
    as _i20; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerThirdsModule = _$RegisterThirdsModule();
  gh.factory<_i3.Dio>(() => registerThirdsModule.dio());
  gh.factory<_i4.HttpClient>(() => _i4.HttpClient(dio: get<_i3.Dio>()));
  gh.factory<_i5.ReportRemoteDataSource>(
      () => _i5.ReportRemoteDataSourceImpl(dioClient: get<_i4.HttpClient>()));
  gh.factory<_i6.CreatePostRemoteDatasource>(() =>
      _i6.CreatePostRemoteDatasourceImpl(httpClient: get<_i4.HttpClient>()));
  gh.factory<_i7.CreatePostRepository>(() => _i8.CreatePostRepositoryImpl(
      createPostRemoteDatasource: get<_i6.CreatePostRemoteDatasource>()));
  gh.factory<_i9.CreatePostUsecase>(() => _i9.CreatePostUsecase(
      createPostRepository: get<_i7.CreatePostRepository>()));
  gh.factory<_i10.CreateTagUsecase>(() => _i10.CreateTagUsecase(
      createPostRepository: get<_i7.CreatePostRepository>()));
  gh.factory<_i11.GetInterestTagsUsecase>(() => _i11.GetInterestTagsUsecase(
      createPostRepository: get<_i7.CreatePostRepository>()));
  gh.singleton<_i12.InterestingTagsStore>(_i12.InterestingTagsStore(
      getTags: get<_i11.GetInterestTagsUsecase>(),
      createTags: get<_i10.CreateTagUsecase>()));
  gh.factory<_i13.ReportPostsRepository>(() => _i14.ReportPostRepositoryImpl(
      remoteDataSource: get<_i5.ReportRemoteDataSource>()));
  gh.factory<_i15.SearchUserByNameUsecase>(() => _i15.SearchUserByNameUsecase(
      createPostRepository: get<_i7.CreatePostRepository>()));
  gh.factory<_i16.SendMediasUsecase>(() => _i16.SendMediasUsecase(
      createPostRepository: get<_i7.CreatePostRepository>()));
  gh.singleton<_i17.StoreCreatePosts>(_i17.StoreCreatePosts(
      searchUser: get<_i15.SearchUserByNameUsecase>(),
      createPostUsecase: get<_i9.CreatePostUsecase>(),
      sendMediasUsecase: get<_i16.SendMediasUsecase>()));
  gh.factory<_i18.ReportPostUseCase>(() => _i18.ReportPostUseCase(
      reportPostRepository: get<_i13.ReportPostsRepository>()));
  gh.factory<_i19.StoreReportPost>(
      () => _i19.StoreReportPost(reportPost: get<_i18.ReportPostUseCase>()));
  return get;
}

class _$RegisterThirdsModule extends _i20.RegisterThirdsModule {}
