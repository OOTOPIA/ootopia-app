import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/clean_arch/report/domain/entity/report_posts_entity.dart';
import 'package:ootopia_app/clean_arch/report/domain/usecases/report_post_usecase.dart';

part "store_report_post.g.dart";

class StoreReportPost = StoreReportPostBase with _$StoreReportPost;

abstract class StoreReportPostBase with Store {
  final ReportPostUseCase _reportPostUsecase;
  StoreReportPostBase({required ReportPostUseCase reportPost})
      : _reportPostUsecase = reportPost;

  @observable
  bool spam = false;

  @observable
  bool nudez = false;

  @observable
  bool violence = false;

  @observable
  bool other = false;

  @observable
  String error = '';

  @observable
  bool success = false;

  @observable
  bool seeMorePostsAboutThisUser = false;

  String reason = '';

  TextEditingController reportController = TextEditingController();

  void setSpam(bool? value) {
    spam = value!;
    reason = 'spam';
  }

  void setNudez(bool? value) {
    nudez = value!;
    reason = 'nudez';
  }

  void setViolence(bool? value) {
    violence = value!;
    reason = 'violence';
  }

  void setOther(bool? value) {
    other = value!;
  }

  void setSeeMorePostsAboutThisUser(bool? value) {
    seeMorePostsAboutThisUser = value!;
  }

  void clearVariables() {
    spam = false;
    nudez = false;
    violence = false;
    other = false;
    error = '';
    success = false;
    seeMorePostsAboutThisUser = false;
    reason = '';
  }

  @action
  Future<void> sendReport(
      {required String idUser, required String idPost}) async {
    error = '';

    if (other) {
      reason = reportController.text;
    }

    ReportPostsEntity postsEntity = ReportPostsEntity(
      denouncedId: idUser,
      postId: idPost,
      visualizerPostUser: seeMorePostsAboutThisUser,
      reason: reason,
    );
    var response = await _reportPostUsecase.call(postsEntity);
    response.fold(
      (failure) => error = failure.message,
      (result) => success = result,
    );
  }
}
