import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:ootopia_app/data/utils/string-utils.dart';

class RegisterPhase2TopInterestsPage extends StatefulWidget {
  @override
  _RegisterPhase2TopInterestsPageState createState() =>
      _RegisterPhase2TopInterestsPageState();
}

class _RegisterPhase2TopInterestsPageState
    extends State<RegisterPhase2TopInterestsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final GlobalKey<TagsState> _tagStateKey2 = GlobalKey<TagsState>();

  List<Item> _topTags = [
    Item(title: 'Agroecologia', active: false, customData: 11),
    Item(title: 'Alimentação', active: false, customData: 3),
    Item(title: 'Ativismo', active: false, customData: 10),
    Item(title: 'Consumo consciente', active: false, customData: 4),
    Item(title: 'Economia solidária', active: false, customData: 0),
    Item(title: 'Educação', active: false, customData: 5),
    Item(title: 'Energia limpa', active: false, customData: 8),
    Item(title: 'Espiritualidade', active: false, customData: 6),
    Item(title: 'Moedas sociais', active: false, customData: 9),
    Item(title: 'Permacultura', active: false, customData: 2),
    Item(title: 'Reciclagem', active: false, customData: 1),
    Item(title: 'Projetos sociais', active: false, customData: 7),
  ];

  List<Item> _secondaryTags = [
    Item(title: 'Água', active: false, customData: 0),
    Item(title: 'Agrofloresta', active: false, customData: 0),
    Item(title: 'Organicos', active: false, customData: 0),
    Item(title: 'Bioconstrução', active: false, customData: 0),
    Item(title: 'Ecologia', active: false, customData: 0),
    Item(title: 'Natureza', active: false, customData: 0),
    Item(title: 'Preservação', active: false, customData: 0),
    Item(title: 'Regeneração', active: false, customData: 0),
    Item(title: 'Sustentabilidade', active: false, customData: 0),
    Item(title: 'Transição', active: false, customData: 0),
    Item(title: 'Povos tradicionais', active: false, customData: 0),
  ];

  List<Item> _secondaryTagsCopy = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _topTags.sort((a, b) => a.customData - b.customData);
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
        child: Center(
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
                              height: GlobalConstants.of(context).logoHeight,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingNormal,
                          ),
                        ),
                        Container(child: tags(_topTags)),
                        SizedBox(
                          height: GlobalConstants.of(context).spacingNormal,
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
                            val =
                                StringUtils.removeDiacritics(val.toLowerCase());
                            setState(() {
                              _secondaryTagsCopy = _secondaryTags.where((tag) {
                                return StringUtils.removeDiacritics(
                                        tag.title.toLowerCase())
                                    .startsWith(val);
                              }).toList();
                            });
                          },
                        ),
                        SizedBox(
                          height: GlobalConstants.of(context).spacingSmall,
                        ),
                        Container(
                          child: tags(_secondaryTagsCopy, this._addTag),
                        ),
                        SizedBox(
                          height: GlobalConstants.of(context).spacingLarge,
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         RegisterPhase2DailyLearningGoalPage(),
                            //   ),
                            // );
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
      ),
    );
  }

  void _addTag(String text, [bool active = false]) {
    setState(() {
      var list = _topTags.where((tag) {
        return StringUtils.removeDiacritics(tag.title.toLowerCase()) ==
            StringUtils.removeDiacritics(text.toLowerCase());
      }).toList();

      if (list.length == 0) {
        _topTags.add(Item(title: text, active: active));
      }
      _secondaryTagsCopy = [];
      FocusScope.of(context).unfocus();
      _inputController.clear();
    });
  }

  tags(List<Item> items, [Function onPressed]) {
    return Tags(
      key: GlobalKey<TagsState>(),
      textField: null,
      //symmetry: true,
      columns: 2,
      alignment: WrapAlignment.start,
      itemCount: items.length, // required
      itemBuilder: (int index) {
        final item = items[index];
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
          onPressed: (item) =>
              onPressed == null ? print(item) : onPressed(item.title, true),
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
