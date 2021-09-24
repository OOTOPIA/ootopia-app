import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/repositories/interests_tags_repository.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:ootopia_app/data/utils/string-utils.dart';
import 'package:ootopia_app/bloc/user/user_bloc.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterPhase2TopInterestsPage extends StatefulWidget {
  final Map<String, dynamic> args;

  RegisterPhase2TopInterestsPage(this.args);

  @override
  _RegisterPhase2TopInterestsPageState createState() =>
      _RegisterPhase2TopInterestsPageState();
}

class _RegisterPhase2TopInterestsPageState
    extends State<RegisterPhase2TopInterestsPage> with SecureStoreMixin {
  UserBloc? userBloc;
  final TextEditingController _inputController = TextEditingController();
  InterestsTagsRepositoryImpl repository = InterestsTagsRepositoryImpl();
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  bool _isLoading = true;
  bool errorOnGetTags = false;

  List<InterestsTags> _selectedTags = [];

  List<InterestsTags> _allTags = [];

  List<Item> _topTags = [];
  List<String> _selectedTagsIds = [];
  List<Item> _secondaryTagsCopy = [];

  late AuthStore authStore;

  void _submit() {
    this
        .trackingEvents
        .signupCompletedStepIVOfSignupII({"tags": _selectedTagsIds});
    _isLoading = false;
    widget.args['user'].registerPhase = state.user.registerPhase;
    widget.args['user'].photoUrl = state.user.photoUrl;
    setCurrentUser(jsonEncode(widget.args['user'].toJson()))
        .then((value) => authStore.setUserIsLogged());
    if (widget.args != null && widget.args['returnToPageWithArgs'] != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageRoute.Page.homeScreen.route,
        ModalRoute.withName('/'),
        arguments: {
          "returnToPageWithArgs": widget.args['returnToPageWithArgs']
        },
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageRoute.Page.homeScreen.route,
        ModalRoute.withName('/'),
      );
    }
  }

  Future<void> getTags() async {
    var getAllTags = await this.repository.getTags();
    _isLoading = false;
    setState(() {
      _allTags.addAll(getAllTags);
    });
    errorOnGetTags = true;
  }

  @override
  void initState() {
    super.initState();
    getTags();
    setState(() {
      _topTags.sort((a, b) => a.customData.tagOrder - b.customData.tagOrder);
    });
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: LoadingOverlay(
          isLoading: _isLoading,
          child: _isLoading
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 33,
                    ),
                    Text(
                      'Favorite Themes',
                      style: TextStyle(
                        color: Color(0xff03145C),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Select the hashtags that correspond to the themes you want to explore and learn.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Select at least 1 hashtag',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: Text(
                                    AppLocalizations.of(context)!
                                        .pleaseSelectAtLeast1Tag,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          decoration:
                                              GlobalConstants.of(context)
                                                  .loginInputTheme(''),
                                        ),
                                        Divider(),
                                        Wrap(
                                          direction: Axis.horizontal,
                                          spacing: 1,
                                          children: _allTags.map((e) {
                                            return FilterChip(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(45)),
                                                  side: BorderSide(
                                                      width: 1,
                                                      color:
                                                          Color(0xffE0E1E2))),
                                              label: Text(
                                                '${e.name}',
                                                style: TextStyle(
                                                    color: e.active
                                                        ? Colors.white
                                                        : Colors.grey),
                                              ),
                                              selectedColor: Color(0xff03145C),
                                              backgroundColor: Colors.white,
                                              selected: e.active,
                                              onSelected: (bool selected) {
                                                setState(() {
                                                  _selectedTags.add(e);
                                                  e.active = selected;
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Color(0xff018F9C),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Confirm',
                                          style: TextStyle(
                                              color: Color(0xff018F9C),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        )),
                                  ],
                                );
                              });
                            });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              Icon(Icons.add),
                              Text(
                                'Select hashtags',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _selectedTags.isEmpty,
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 1,
                        children: _selectedTags.map((e) {
                          return FilterChip(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45)),
                                side: BorderSide(
                                    width: 1, color: Color(0xffE0E1E2))),
                            label: Text(
                              '${e.name}',
                              style: TextStyle(
                                  color: e.active ? Colors.white : Colors.grey),
                            ),
                            selectedColor: Color(0xff03145C),
                            backgroundColor: Colors.white,
                            selected: e.active,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedTags.add(e);
                                e.active = selected;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _addTag(Item item, [bool active = false]) {
    setState(() {
      var list = _topTags.where((tag) {
        return StringUtils.removeDiacritics(tag.title!.toLowerCase()) ==
            StringUtils.removeDiacritics(item.title!.toLowerCase());
      }).toList();

      if (list.length == 0) {
        _topTags.add(Item(
          title: item.title,
          active: active,
          customData: item.customData,
        ));
        _toggleSelectedTagsIds(item);
      }
      _secondaryTagsCopy = [];
      FocusScope.of(context).unfocus();
      _inputController.clear();
    });
  }

  void _toggleSelectedTagsIds(Item item) {
    setState(() {
      if (_selectedTagsIds.indexOf(item.customData.id) == -1) {
        _selectedTagsIds.add(item.customData.id);
      } else {
        _selectedTagsIds.remove(item.customData.id);
      }
    });
  }

  tags(List<Item> items, [Function? onPressed]) {
    //Quando atualizamos a view com o setState, as tags selecionadas eram deselecionadas, então o código abaixo corrige isso
    List<Item> itemsCopy = [];
    items.forEach((item) {
      itemsCopy.add(Item(
        title: item.title,
        active: _selectedTagsIds.indexOf(item.customData.id) != -1,
        customData: item.customData,
      ));
    });
    if (itemsCopy.length <= 0) {
      return Container();
    }
    return Tags(
      key: GlobalKey<TagsState>(),
      textField: null,
      //symmetry: true,
      columns: 2,
      alignment: WrapAlignment.start,
      itemCount: itemsCopy.length, // required
      itemBuilder: (int index) {
        final item = itemsCopy[index];
        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item.title!,
          active: item.active!,
          customData: item.customData,
          activeColor: Color(0xff0B8C1E),
          textStyle: TextStyle(
            fontSize: 14,
          ),
          combine: ItemTagsCombine.onlyText,
          image: null, // OR null,
          icon: null, // OR null,
          border: null,
          removeButton: null, // OR null,
          textScaleFactor: 1.1,
          onPressed: (item) => onPressed == null
              ? _toggleSelectedTagsIds(item)
              : onPressed(item, true),
          onLongPressed: (item) => print(item),
          alignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }
}
