import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/components/share_link.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopupMenuPost extends StatefulWidget {
  final bool isAnabled;
  final Function callbackReturnPopupMenu;
  final TimelinePost post;

  PopupMenuPost({
    required this.isAnabled,
    required this.callbackReturnPopupMenu,
    required this.post,
  });
  @override
  _PopupMenuPostState createState() => _PopupMenuPostState();
}

class _PopupMenuPostState extends State<PopupMenuPost> with SecureStoreMixin {
  bool loggedIn = false;
  User? user;
  bool isUserOwnsPost = false;

  _checkUserIsLoggedInAndUserOwnsThePost() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      isUserOwnsPost = user!.id == widget.post.userId;
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
    if (optionSelected == 'shared') {
      copyLink(Type.posts, widget.post.id);
      modalSharedCopyLink(Type.posts, context);
      return;
    }

    if (isUserOwnsPost && optionSelected == 'delete') {
      widget.callbackReturnPopupMenu(optionSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: Column(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    child: SvgPicture.asset(
                      'assets/icons/link.svg',
                      color: Color(0xff707070),
                    ),
                    padding: EdgeInsets.only(right: 4),
                  ),
                  Text(
                    AppLocalizations.of(context)!.copyLink,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          value: 'shared',
        ),
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
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
          value: 'delete',
        ),
      ],
      onSelected: (String value) => _selectedOption(value),
    );
  }
}
