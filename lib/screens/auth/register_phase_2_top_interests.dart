import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/interests_tags_repository.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:ootopia_app/data/utils/string-utils.dart';
import 'package:ootopia_app/bloc/user/user_bloc.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class RegisterPhase2TopInterestsPage extends StatefulWidget {
  final User user;

  RegisterPhase2TopInterestsPage(this.user);

  @override
  _RegisterPhase2TopInterestsPageState createState() =>
      _RegisterPhase2TopInterestsPageState();
}

class _RegisterPhase2TopInterestsPageState
    extends State<RegisterPhase2TopInterestsPage> with SecureStoreMixin {
  UserBloc userBloc;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final GlobalKey<TagsState> _tagStateKey2 = GlobalKey<TagsState>();
  InterestsTagsRepositoryImpl repository = InterestsTagsRepositoryImpl();

  bool _isLoading = true;
  bool errorOnGetTags = false;

  List<InterestsTags> _allTags = [];

  List<Item> _topTags = [];
  List<Item> _secondaryTags = [];
  List<String> _selectedTagsIds = [];
  List<Item> _secondaryTagsCopy = [];

  void _submit() {
    userBloc.add(UpdateUserEvent(widget.user, _selectedTagsIds));
  }

  Future<void> getTags() async {
    this.repository.getTags().then((tags) {
      setState(() {
        _isLoading = false;
        if (tags == null) {
          return;
        }
        _allTags = tags;
        _allTags.forEach((tag) {
          if (tag.type == "top") {
            _topTags.add(Item(title: tag.name, active: false, customData: tag));
          } else {
            _secondaryTags
                .add(Item(title: tag.name, active: false, customData: tag));
          }
        });
        print("Total tags count: ${tags.length}");
      });
    }).onError((error, stackTrace) {
      setState(() {
        errorOnGetTags = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    getTags();
    setState(() {
      _topTags.sort((a, b) => a.customData.tagOrder - b.customData.tagOrder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UpdateUserErrorState) {
              _isLoading = false;
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is LoadingState) {
              _isLoading = true;
            } else if (state is UpdateUserSuccessState) {
              _isLoading = false;
              widget.user.registerPhase = 2;
              widget.user.photoUrl = state.user.photoUrl;
              setCurrentUser(jsonEncode(widget.user.toJson()));
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return TimelinePage();
                },
              ), (Route<dynamic> route) => false);
            }
          },
          child: _blocBuilder(),
        ),
      ),
    );
  }

  void _tryAgain() {
    setState(() {
      errorOnGetTags = false;
      _isLoading = true;
      getTags();
    });
  }

  _blocBuilder() {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (errorOnGetTags) {
        return TryAgain(
          this._tryAgain,
          buttonBackgroundColor: Colors.white,
          messageTextColor: Colors.white,
          buttonTextColor: Colors.black,
        );
      }
      return ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: _isLoading
            ? Container()
            : Center(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(
                            GlobalConstants.of(context).spacingMedium,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/white_logo.png',
                                    height:
                                        GlobalConstants.of(context).logoHeight,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      GlobalConstants.of(context).spacingNormal,
                                ),
                              ),
                              Container(child: tags(_topTags)),
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal,
                              ),
                              TextFormField(
                                textAlign: TextAlign.center,
                                controller: _inputController,
                                autofocus: false,
                                decoration: GlobalConstants.of(context)
                                    .loginInputTheme("Others"),
                                onChanged: (String val) {
                                  if (val.isEmpty) {
                                    setState(() {
                                      _secondaryTagsCopy = [];
                                    });
                                    return;
                                  }
                                  val = StringUtils.removeDiacritics(
                                      val.toLowerCase());
                                  setState(() {
                                    _secondaryTagsCopy =
                                        _secondaryTags.where((tag) {
                                      return StringUtils.removeDiacritics(
                                              tag.title.toLowerCase())
                                          .startsWith(val);
                                    }).toList();
                                  });
                                },
                              ),
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingSmall,
                              ),
                              Container(
                                child: tags(_secondaryTagsCopy, this._addTag),
                              ),
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingLarge,
                              ),
                              FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    GlobalConstants.of(context).spacingNormal,
                                  ),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  print("pressed!!");
                                  setState(() {
                                    _submit();
                                  });
                                },
                                color: Colors.white,
                                splashColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      );
    });
  }

  void _addTag(Item item, [bool active = false]) {
    setState(() {
      var list = _topTags.where((tag) {
        return StringUtils.removeDiacritics(tag.title.toLowerCase()) ==
            StringUtils.removeDiacritics(item.title.toLowerCase());
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

  tags(List<Item> items, [Function onPressed]) {
    //Quando atualizamos a view com o setState, as tags selecionadas eram deselecionadas, então o código abaixo corrige isso
    List<Item> itemsCopy = [];
    items.forEach((item) {
      itemsCopy.add(Item(
        title: item.title,
        active: _selectedTagsIds.indexOf(item.customData.id) != -1,
        customData: item.customData,
      ));
    });
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
          title: item.title,
          active: item.active,
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

// Allows you to get a list of all the ItemTags
  _getAllItem() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null)
      lst.where((a) => a.active == true).forEach((a) => print(a.title));
  }
}
