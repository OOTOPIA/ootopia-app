import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/data/models/users/user_search_model.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_store.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';

class ListOfUsers extends StatefulWidget {
  final CommentStore commentStore;
  final TextEditingController inputController;
  final ScrollController scrollController;
  final Function(UserSearchModel)? addUserInText;
  ListOfUsers({
    Key? key,
    required this.commentStore,
    required this.inputController,
    required this.scrollController,
    this.addUserInText,
  }) : super(key: key);

  @override
  State<ListOfUsers> createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers> {
  @override
  Widget build(BuildContext context) {
    final sizeKeyboard = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance!.window.viewInsets,
      WidgetsBinding.instance!.window.devicePixelRatio,
    ).bottom;
    final multiple = MediaQuery.of(context).size.height > 650 ? 180 : 150;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.white,
        height: (MediaQuery.of(context).size.height - sizeKeyboard) - multiple,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Observer(builder: (context) {
            if (widget.commentStore.viewState == ViewState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              children: [
                BackgroundButterflyTop(positioned: -59),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.commentStore.listAllUsers
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: () {
                                widget.addUserInText!(e);
                              },
                              child: Row(
                                children: [
                                  if (e.photoUrl != null)
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          NetworkImage(e.photoUrl!),
                                    )
                                  else
                                    CircleAvatar(
                                      radius: 25,
                                      child: Image.asset(
                                        'assets/icons/user.png',
                                      ),
                                    ),
                                  SizedBox(width: 8),
                                  Text(e.fullname),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (widget.commentStore.viewState == ViewState.loadingNewData)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
