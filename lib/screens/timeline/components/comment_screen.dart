import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/comment/comment_bloc.dart';
import 'package:ootopia_app/data/models/comments/comment_create_model.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/login_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class CommentScreen extends StatefulWidget {
  final TimelinePost post;

  CommentScreen({this.post});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> with SecureStoreMixin {
  TextEditingController _inputController = TextEditingController();
  User user;

  CommentBloc commentBloc;

  bool newCommentLoading = false;
  bool loggedIn = false;
  bool selectMode = false;
  bool allCommentsLoaded = false;
  bool loadingMoreComments = false;
  int currentPage = 1;

  List<String> selectedCommentsIds = [];

  void initState() {
    _checkUserIsLoggedIn();
    commentBloc = BlocProvider.of<CommentBloc>(context);
    _getComments([]);
  }

  bool _enabledToDeleteOtherComments() {
    return this.user != null && this.user.id == widget.post.userId;
  }

  Future<void> _getComments(List<Comment> allComments,
      [bool loadingMore = false]) async {
    commentBloc.add(GetCommentEvent(
      postId: widget.post.id,
      page: currentPage,
      allComments: allComments,
      loadingMore: loadingMore,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _removeFocusInput(),
      child: Scaffold(
        appBar: CustomAppBar(
          selectedCommentsIds.length > 0
              ? selectedCommentsIds.length.toString() +
                  ' selecionado' +
                  (selectedCommentsIds.length > 1 ? 's' : '')
              : 'Comentários',
          selectedCommentsIds.length > 0
              ? Icon(Icons.close)
              : Icon(Icons.chevron_left),
          selectedCommentsIds.length > 0,
          this._onLeadingClick,
          this._onDeleteClick,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocListener<CommentBloc, CommentState>(
              listener: (context, state) {},
              child: _blocBuilder(),
            ),
            BlocListener<CommentBloc, CommentState>(
              listener: (context, state) {
                if (state is CommentSuccessState) {
                  if (state.newCommentIsAdded) {
                    newCommentLoading = false;
                  }
                  allCommentsLoaded = state.allCommentsLoaded;
                  loadingMoreComments = false;
                }
              },
              child: BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _inputController,
                      decoration: InputDecoration(
                        labelText: 'Escreva seu comentário',
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: newCommentLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 14.0),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                ],
                              )
                            : IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () => _addComment(),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return Expanded(
            flex: 1,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CommentSuccessState) {
          if (state.comments == null || state.comments.length <= 0) {
            return Expanded(
              flex: 1,
              child: Center(
                child: Text('Nenhum comentário'),
              ),
            );
          }
          return Expanded(
            flex: 1,
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  state.comments = [];
                  selectedCommentsIds = [];
                  selectMode = false;
                  currentPage = 1;
                  loadingMoreComments = false;
                });
                _getComments(state.comments);
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.comments.length + 1,
                itemBuilder: (context, index) {
                  if (index > 0 && index == state.comments.length) {
                    if (allCommentsLoaded) {
                      return Container();
                    }
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(
                            GlobalConstants.of(context).spacingSmall),
                        child: IconButton(
                          icon: loadingMoreComments
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(),
                                )
                              : ImageIcon(
                                  AssetImage('assets/icons/add.png'),
                                  color: Colors.black,
                                ),
                          onPressed: () {
                            setState(() {
                              currentPage = currentPage + 1;
                              loadingMoreComments = true;
                            });
                            _getComments(state.comments, true);
                          },
                          color: Colors.black,
                        ),
                      ),
                    );
                  }

                  Comment comment = state.comments[index];
                  return GestureDetector(
                    onLongPress: () {
                      if (this._enabledToDeleteOtherComments() ||
                          this.user.id == comment.userId) {
                        this._toggleSelectedComment(comment);
                      }
                    },
                    onTap: () {
                      if (this._enabledToDeleteOtherComments() ||
                          (this.user != null &&
                              this.user.id == comment.userId)) {
                        if (!selectMode) {
                          setState(() {
                            if (selectedCommentsIds.indexOf(comment.id) != -1) {
                              selectedCommentsIds.remove(comment.id);
                              comment.selected = false;
                              commentBloc.add(OnToggleSelectCommentEvent(
                                comment: comment,
                              ));
                            }
                          });
                        } else {
                          this._toggleSelectedComment(comment);
                        }
                      }
                    },
                    child: CommentItem(
                      currentUser: this.user,
                      comment: comment,
                      enabledToDeleteOtherComments:
                          this._enabledToDeleteOtherComments(),
                      selectMode: selectMode,
                    ),
                  );
                },
              ),
            ),
          );
        }
        return Expanded(
          flex: 1,
          child: Center(
            child: Text('Nenhum comentário'),
          ),
        );
      },
    );
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      print("LOGGED USER: " + user.fullname);
    }
  }

  void _addComment() {
    if (_inputController.text.length <= 0) {
      return;
    }

    if (!loggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    } else {
      setState(() {
        newCommentLoading = true;
        commentBloc.add(
          CreateCommentEvent(
            comment: CommentCreate(
                postId: widget.post.id, text: _inputController.text),
          ),
        );
      });
    }

    _inputController.clear();
    _removeFocusInput();
  }

  void _removeFocusInput() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  void _toggleSelectedComment(Comment comment) {
    setState(() {
      if (selectedCommentsIds.indexOf(comment.id) == -1) {
        selectedCommentsIds.add(comment.id);
        comment.selected = true;
      } else {
        selectedCommentsIds.remove(comment.id);
        comment.selected = false;
      }
      selectMode = selectedCommentsIds.length > 0;
      commentBloc.add(OnToggleSelectCommentEvent(comment: comment));
    });
  }

  void _onLeadingClick(BuildContext context) {
    if (selectedCommentsIds.length > 0) {
      setState(() {
        selectMode = false;
        selectedCommentsIds = [];
        commentBloc.add(UnselectAllCommentsEvent());
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _onDeleteClick() {
    _showDeleteCommentsDialog();
    /*commentBloc.add(DeleteSelectedCommentsEvent(selectedCommentsIds));
    setState(() {
      selectMode = false;
      selectedCommentsIds = [];
    });*/
  }

  Future<void> _showDeleteCommentsDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Atenção',
            style: Theme.of(context).textTheme.headline2,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Os comentários serão removidos permanentemente.',
                    style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                commentBloc.add(DeleteSelectedCommentsEvent(
                    widget.post.id, selectedCommentsIds));
                setState(() {
                  selectMode = false;
                  selectedCommentsIds = [];
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  User currentUser;
  Comment comment;
  bool enabledToDeleteOtherComments;
  bool selectMode;

  CommentItem(
      {this.currentUser,
      this.comment,
      this.enabledToDeleteOtherComments,
      this.selectMode});

  bool _enabledToDeleteOtherComments() {
    return enabledToDeleteOtherComments ||
        (this.currentUser != null && this.currentUser.id == comment.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          (_enabledToDeleteOtherComments() ? 1.0 : (selectMode ? 0.5 : 1.0)),
      child: Container(
        decoration: (comment.selected
            ? BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.grey.withOpacity(0.3),
              )
            : BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
              )),
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(this.comment.photoUrl == null
                        ? (this.currentUser != null &&
                                this.currentUser.id == this.comment.userId &&
                                this.currentUser.photoUrl != null
                            ? this.currentUser.photoUrl
                            : "")
                        : this.comment.photoUrl),
                    minRadius: 16,
                  ),
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      text: (this.comment.username != null
                              ? this.comment.username
                              : (this.currentUser != null &&
                                      this.currentUser.fullname != null
                                  ? this.currentUser.fullname
                                  : "")) +
                          ': ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: this.comment.text,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final Icon icon;
  final bool hasselectedCommentsIds;
  final Function onLeadingClick;
  final Function onDeleteClick;

  CustomAppBar(
    this.title,
    this.icon,
    this.hasselectedCommentsIds,
    this.onLeadingClick,
    this.onDeleteClick, {
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: hasselectedCommentsIds ? Colors.white : Colors.black),
      ),
      backgroundColor:
          hasselectedCommentsIds ? Theme.of(context).accentColor : Colors.white,
      leading: IconButton(
        icon: this.icon,
        onPressed: () => this.onLeadingClick(context),
        color: hasselectedCommentsIds ? Colors.white : Colors.black,
      ),
      actions: [
        Visibility(
          visible: hasselectedCommentsIds,
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => this.onDeleteClick(),
            color: Colors.white,
          ),
        ),
      ],
      //automaticallyImplyLeading: true,
    );
  }
}
