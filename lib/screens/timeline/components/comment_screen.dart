import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/comment/comment_bloc.dart';
import 'package:ootopia_app/data/models/comments/comment_create_model.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';

class CommentScreen extends StatefulWidget {
  final List<Comment> _comments = List();
  final String postId;

  CommentScreen({this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _inputController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  CommentBloc commentBloc;

  bool newCommentLoading = false;

  void initState() {
    commentBloc = BlocProvider.of<CommentBloc>(context);
    commentBloc.add(GetCommentEvent(postId: widget.postId));
  }

  void _addComment() {
    print("Add Comment");
    setState(() {
      newCommentLoading = true;
      commentBloc.add(
        CreateCommentEvent(
          comment:
              CommentCreate(postId: widget.postId, text: _inputController.text),
        ),
      );
    });

    _inputController.clear();
    _removeFocusInput();
  }

  void _removeFocusInput() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  Future<void> _getData() async {
    setState(() {
      commentBloc.add(GetCommentEvent(postId: widget.postId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _removeFocusInput(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comentarios'),
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
                        suffix: newCommentLoading
                            ? CircularProgressIndicator()
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
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CommentSuccessState) {
          if (state.comments == null || state.comments.length <= 0) {
            return Center(
              child: Text('Nenhum comentário'),
            );
          }
          return Expanded(
            flex: 1,
            child: RefreshIndicator(
              onRefresh: () async {
                state.comments = [];
                _getData();
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.comments.length,
                itemBuilder: (context, index) {
                  return CommentItem(
                    photoUrl: state.comments[index].photoUrl,
                    text: state.comments[index].text,
                    username: state.comments[index].username,
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  String photoUrl;
  String username;
  String text;

  CommentItem({this.photoUrl, this.username, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage("${this.photoUrl}"),
              minRadius: 16,
            ),
          ),
          Flexible(
            child: RichText(
              text: TextSpan(
                text: (this.username != null ? this.username : "") + ': ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                    text: this.text,
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
    );
  }
}
