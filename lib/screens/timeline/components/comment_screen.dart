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

  CommentBloc commentBloc;

  void initState() {
    commentBloc = BlocProvider.of<CommentBloc>(context);
    commentBloc.add(GetCommentEvent(postId: widget.postId));
  }

  void _addComment() {
    print("Hello");

    CommentCreate commentCreate =
        CommentCreate(postId: widget.postId, text: _inputController.toString());

    // bloc.createComment.add(commentCreate);

    // setState(() {
    //   widget._comments.add(commentCreate);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comentário',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _addComment(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
      if (state is LoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is CommentErrorState) {
        return Center(
          child: Text('Nenhum comentário'),
        );
      } else if (state is CommentSuccessState) {
        return Column(
          children: <Widget>[
            Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    // state.comments = [];
                    // _getData();
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
                  )),
            ),
          ],
        );
      }
    });
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
          Text(
            this.username + ': ',
            textAlign: TextAlign.start,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            this.text,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
