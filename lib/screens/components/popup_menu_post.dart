import 'package:flutter/material.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class PopupMenuPost extends StatefulWidget {
  final bool isAnabled;
  final Function callbackReturnPopupMenu;
  final post;

  PopupMenuPost({this.isAnabled, this.callbackReturnPopupMenu, this.post});
  @override
  _PopupMenuPostState createState() => _PopupMenuPostState();
}

class _PopupMenuPostState extends State<PopupMenuPost> with SecureStoreMixin {
  bool loggedIn = false;
  User user;
  bool isUserOwnsPost = false;

  _checkUserIsLoggedInAndUserOwnsThePost() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      isUserOwnsPost = user.id == widget.post.userId;
    } else {
      isUserOwnsPost = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedInAndUserOwnsThePost();
  }

  _selectedOption(String optionSelected) {
    if (!isUserOwnsPost) {
      return 'isUserNotOwnsPost';
    }

    switch (optionSelected) {
      case 'Excluir':
        widget.callbackReturnPopupMenu(optionSelected);

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: Opacity(
            opacity: isUserOwnsPost ? 1.0 : .4,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  child: Icon(Icons.delete),
                  padding: EdgeInsets.only(right: 4),
                ),
                Text(
                  'Excluir',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
          value: 'Excluir',
        ),
      ],
      onSelected: (_) => _selectedOption(_),
    );
  }
}
