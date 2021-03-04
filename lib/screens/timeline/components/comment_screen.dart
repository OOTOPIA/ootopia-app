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
  final TextEditingController _inputController = TextEditingController();
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
    });
    commentBloc.add(
      CreateCommentEvent(
        comment:
            CommentCreate(postId: widget.postId, text: _inputController.text),
      ),
    );

    _inputController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      body: BlocListener<CommentBloc, CommentState>(
        listener: (context, state) {
          print("State changes");
          if (state is CommentSuccessState) {
            print("SOME O CARREGANDO");
            newCommentLoading = false;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: _blocBuilder()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _inputController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Comentário',
                  hintStyle: TextStyle(color: Colors.black),
                  suffix: newCommentLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _addComment(),
                        ),
                ),
              ),
            )
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
        } else if (state is CommentErrorState) {
          return Center(
            child: Text('Nenhum comentário'),
          );
        } else if (state is CommentSuccessState) {
          print("SUCCESS STATE");
          return Center(
            child: Column(
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () async {
                    // state.comments = [];
                    // _getData();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
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
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'nothing data :(',
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  String photoUrl = '';
  String username = '';
  String text = '';

  CommentItem({this.photoUrl, this.username, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                  fontSize: 16,
                ),
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
