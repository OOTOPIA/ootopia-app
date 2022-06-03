import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/post_preview_screen_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOfUsers extends StatefulWidget {
  ListOfUsers({
    Key? key,
  }) : super(key: key);

  @override
  State<ListOfUsers> createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers> {
  final ScrollController scrollController = ScrollController();
  final StoreCreatePosts createPosts = GetIt.I.get();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .4,
        width: MediaQuery.of(context).size.width,
        child: NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                !createPosts.lastPage) {
              createPosts.getMoreUsers();
            }
            return true;
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Observer(builder: (context) {
              if (createPosts.viewState == ViewState.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (createPosts.users.isEmpty &&
                  createPosts.fullName.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    createPosts.openSelectedUser = false;
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        BackgroundButterflyTop(positioned: -59),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.userNotFound,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff707070),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .userNotFoundInTaggedUser,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff707070),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Observer(builder: (context) {
                return Stack(
                  children: [
                    BackgroundButterflyTop(positioned: -59),
                    BackgroundButterflyBottom(positioned: -50),
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: createPosts.users
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    createPosts.addUserInText(e);
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
                    if (createPosts.viewState == ViewState.loadingNewData)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                );
              });
            }),
          ),
        ),
      ),
    );
  }
}
