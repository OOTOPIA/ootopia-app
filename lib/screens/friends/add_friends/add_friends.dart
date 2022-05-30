import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/friends/add_friends/body_add_friends.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/friends/get_contacts.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

import '../../auth/auth_store.dart';

class AddFriends extends StatefulWidget {
  final bool displayContacts;
  final dynamic arguments;
  final bool displayModal;
  AddFriends({
    this.displayContacts = false,
    this.displayModal = false,
    this.arguments,
  });
  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  late AuthStore authStore;
  TextEditingController messageController = TextEditingController();
  SmartPageController controller = SmartPageController.getInstance();
  late FriendsStore friendsStore;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      friendsStore.cleanSearchPage();
      if (widget.displayContacts || widget.displayModal) {
        askPermissions(context, friendsStore, widget.displayModal);
        await authStore.checkUserIsLogged();
      }
    });
  }

  void redirectToHomePage() async {
    if (widget.arguments['goal'] != null &&
        widget.arguments['goal'] == 'invitationCode') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageRoute.Page.celebration.route,
            (Route<dynamic> route) => false,
        arguments: widget.arguments,
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageRoute.Page.homeScreen.route,
            (Route<dynamic> route) => false,
        arguments: widget.arguments,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    friendsStore = Provider.of<FriendsStore>(context);
    authStore = Provider.of<AuthStore>(context);
    return Consumer<FriendsStore>(builder: (cont, counter, _) {
      if (widget.displayContacts) {
        return Scaffold(
          appBar: defaultAppBar,
          body: BodyAddFriends(
            authStore: authStore,
            displayContacts: widget.displayContacts,
            displayModal: widget.displayModal,
            showAmountOfFriends: showAmountOfFriends(),
            messageController: messageController,
            friendsStore: friendsStore,
            controller: controller,
          ),
        );
      }
      return BodyAddFriends(
          authStore: authStore,
          displayContacts: widget.displayContacts,
          displayModal: widget.displayModal,
          showAmountOfFriends: showAmountOfFriends(),
          messageController: messageController,
          friendsStore: friendsStore,
          controller: controller);
    });
  }

  get defaultAppBar => DefaultAppBar(
    components: [
      AppBarComponents.keep,
    ],
    onTapAction: redirectToHomePage,
  );





  bool showAmountOfFriends() {
    return !widget.displayContacts &&
        !widget.displayModal &&
        (friendsStore.usersSearch.total != null) &&
        !friendsStore.isLoading &&
        !(friendsStore.usersSearch.friends?.isEmpty ?? true);
  }
}
