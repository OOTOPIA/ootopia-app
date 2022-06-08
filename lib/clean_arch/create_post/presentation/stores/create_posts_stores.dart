import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/clean_arch/core/constants/colors.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/async_states.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_post_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/search_user_by_name_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/send_medias_usecase.dart';
import 'package:ootopia_app/shared/geolocation.dart';
import 'package:ootopia_app/shared/rich_text_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'create_posts_stores.g.dart';

class StoreCreatePosts = StoreCreatePostsBase with _$StoreCreatePosts;

abstract class StoreCreatePostsBase with Store {
  final SearchUserByNameUsecase _searchUserByNameUsecase;
  final CreatePostUsecase _createPostUsecase;
  final SendMediasUsecase _mediasUsecase;

  RichTextController _descriptionInputController = RichTextController(
    deleteOnBack: false,
    patternMatchMap: {
      RegExp(r'((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?'):
          const TextStyle(
        color: LightColors.linkText,
      ),
    },
    onMatch: (List<String> matches) {},
  );
  StoreCreatePostsBase({
    required SearchUserByNameUsecase searchUser,
    required CreatePostUsecase createPostUsecase,
    required SendMediasUsecase sendMediasUsecase,
  })  : _searchUserByNameUsecase = searchUser,
        _createPostUsecase = createPostUsecase,
        _mediasUsecase = sendMediasUsecase;

  @observable
  List<UsersEntity>? listTaggedUsers = ObservableList.of([]);

  @observable
  List<UsersEntity> users = ObservableList.of([]);

  List<String> idsUsersTagged = [];

  List<String> tagsid = [];

  @observable
  String fullName = '';

  @observable
  String error = '';

  @observable
  String? excludedIds = '';

  @observable
  String geolocationErrorMessage = '';

  @observable
  String geolocationMessage = 'Please, wait...';

  @observable
  Timer? _debounce;

  @observable
  bool lastPage = false;

  @observable
  bool openSelectedUser = false;

  @observable
  AsyncStates viewState = AsyncStates.done;

  @observable
  int page = 0;

  @observable
  CreatePostEntity postEntity = CreatePostEntity();

  @computed
  RichTextController get descriptionInputController =>
      _descriptionInputController;

  @action
  void addUserInText(UsersEntity e) {
    var text = _descriptionInputController.text;

    var name = '‌@${e.fullname}‌';
    var nameStartRange = 0;
    for (var i = text.length - 1; i >= 0; i--) {
      if (text[i].contains('@')) {
        _descriptionInputController.text =
            text.replaceRange(i, i + nameStartRange + 1, name);
        nameStartRange = i;
        break;
      }
      nameStartRange++;
    }

    if (excludedIds!.isEmpty) {
      excludedIds = excludedIds! + '${e.id}';
    } else {
      excludedIds = excludedIds! + ',${e.id}';
    }
    listTaggedUsers?.add(e);
    _descriptionInputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _descriptionInputController.text.length));
    openSelectedUser = false;
  }

  @action
  void onChanged(String value) {
    value = value.trim();
    if (value.length >= 1) {
      var endName = 0;
      for (var item in listTaggedUsers!) {
        var startname = value.indexOf('@${item.fullname}', endName);

        if (startname < 0) {
          if (excludedIds!.contains(',${item.id}')) {
            excludedIds = excludedIds?.replaceAll(',${item.id}', '');
          } else {
            if (excludedIds!.contains('${item.id},')) {
              excludedIds = excludedIds?.replaceAll('${item.id},', '');
            } else {
              excludedIds = excludedIds?.replaceAll('${item.id}', '');
            }
          }
          listTaggedUsers?.remove(item);
          break;
        }
        endName = startname + item.fullname.length + 3;
      }
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(Duration(seconds: 1, milliseconds: 700), () async {
        var getLastString = value.split('‌@');
        if (getLastString.last.contains('@')) {
          openSelectedUser = true;
          var startName = getLastString.last.split('@').last;
          var finishName = startName.split('‌');
          page = 1;
          fullName = finishName.first;
          await searchUser();
        } else {
          openSelectedUser = false;
        }
      });
    } else {
      openSelectedUser = false;
      listTaggedUsers?.clear();
      excludedIds = '';
      fullName = '';
    }
  }

  void cancelTimer() {
    if (_debounce != null) _debounce!.cancel();
  }

  void _startLoading() => viewState = AsyncStates.loading;

  bool get loading => viewState == AsyncStates.loading;

  void _incrementPage() => page += 1;

  void _stopGetPost(List<UsersEntity> list) => lastPage = list.isEmpty;

  void _stopLoading({bool hasError = false}) {
    viewState = hasError ? AsyncStates.error : AsyncStates.done;
  }

  void _setUsers(List<UsersEntity> list) {
    if (list.isNotEmpty) {
      users = ObservableList.of([...users, ...list]);
    }
  }

  @action
  Future<void> searchUser() async {
    _startLoading();
    var _response = await _searchUserByNameUsecase.call(
      fullName: fullName,
      page: page,
      excludedIds: excludedIds,
    );
    _response.fold(
      (failure) => _stopLoading(hasError: true),
      (result) {
        _setUsers(result);
        _stopGetPost(result);
        _stopLoading();
      },
    );
  }

  @action
  Future<void> getMoreUsers() async {
    if (!lastPage) {
      _incrementPage();
      searchUser();
    }
  }

  @action
  void taggedUserInText() {
    var newTextComment = _descriptionInputController.text;

    if (listTaggedUsers != null) {
      int newStartIndex = 0;
      int endNameUser = 0;
      listTaggedUsers?.forEach((user) {
        idsUsersTagged.add(user.id);
        String newString = '@[${user.id}]';
        var startname =
            newTextComment.indexOf('‌@${user.fullname}‌', endNameUser);

        newTextComment = newTextComment.replaceRange(
          startname + newStartIndex,
          user.fullname.length + startname + newStartIndex + 3,
          newString,
        );
        endNameUser = user.id.length + startname + 3;
        newStartIndex =
            newStartIndex + newString.length - (endNameUser - startname);
      });
    }
  }

  void getLocation(BuildContext context) async {
    geolocationErrorMessage = '';
    geolocationMessage = AppLocalizations.of(context)!.pleaseWait;
    try {
      var position = await Geolocation.determinePosition(context);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.length > 0) {
        var placemark = placemarks[0];

        postEntity.addressCity = placemark.subAdministrativeArea ?? '';
        postEntity.addressState = placemark.administrativeArea ?? '';
        postEntity.addressCountryCode = placemark.isoCountryCode ?? '';
        postEntity.addressLatitude = position.latitude;
        postEntity.addressLongitude = position.longitude;
        postEntity.addressNumber = placemark.name ?? '';
      } else {
        geolocationMessage =
            AppLocalizations.of(context)!.failedToGetCurrentLocation;
        geolocationErrorMessage =
            AppLocalizations.of(context)!.weCouldntGetYourLocation2;
      }
    } catch (error) {
      geolocationMessage =
          AppLocalizations.of(context)!.failedToGetCurrentLocation;
      geolocationErrorMessage = error.toString();
    }
  }

  Future<void> sendMedia(List<Map> fileList) async {
    _startLoading();

    List<String> mediaIds = [];
    for (var file in fileList) {
      var result = await _mediasUsecase(
        type: file['mediaType'],
        file: file['mediaFile'],
      );
      result.fold(
        (left) => error = left.message,
        (right) => mediaIds.add(right),
      );
    }
    postEntity.mediaIds = mediaIds;
    await sendPost();
  }

  @action
  Future<void> sendPost() async {
    taggedUserInText();
    postEntity.description = _descriptionInputController.text;
    postEntity.taggedUsersId = idsUsersTagged;
    postEntity.tagsIds = tagsid;

    var response = await _createPostUsecase.call(postEntity);
    response.fold(
      (left) => _stopLoading(hasError: true),
      (right) {
        _stopLoading();
      },
    );
  }

  void clearVariable() {
    tagsid = ObservableList.of([]);
    _descriptionInputController.clear();
    listTaggedUsers = ObservableList.of([]);
    users = ObservableList.of([]);
    idsUsersTagged = [];
    tagsid = [];
    fullName = '';
    excludedIds = '';
    geolocationErrorMessage = '';
    geolocationMessage = 'Please, wait...';
    lastPage = false;
    openSelectedUser = false;
    viewState = AsyncStates.done;
    page = 1;
  }
}
