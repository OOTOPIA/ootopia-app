import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/clean_arch/report/domain/entity/report_posts_entity.dart';
import 'package:ootopia_app/clean_arch/report/domain/entity/state_report.dart';
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
  bool success = true;

  @observable
  bool seeMorePostsAboutThisUser = false;

  TextEditingController reportController = TextEditingController();

  void setSpam(bool? value) {
    spam = value!;
  }

  void setNudez(bool? value) {
    nudez = value!;
  }

  void setViolence(bool? value) {
    violence = value!;
  }

  void setOther(bool? value) {
    other = value!;
  }

  void setSeeMorePostsAboutThisUser(bool? value) {
    seeMorePostsAboutThisUser = value!;
  }

  Future<void> sendReport() async {
    error = '';
    ReportPostsEntity postsEntity = ReportPostsEntity(
      idUser: 'idUser',
      stateReport: StateReport.dale,
      text: reportController.text,
    );
    var response = await _reportPostUsecase.call(postsEntity);
    response.fold(
      (failure) => error = failure.message,
      (result) => success = true,
    );
  }
}
