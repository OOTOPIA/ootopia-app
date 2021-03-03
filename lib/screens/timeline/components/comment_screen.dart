import 'package:flutter/material.dart';
import 'package:ootopia_app/bloc/comment/comment_bloc.dart';
import 'package:ootopia_app/data/models/comments/comment_create_model.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';

class CommentScreen extends StatefulWidget {
  final List<Comment> _comments = List();

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _inputController = TextEditingController();

  CommentBloc bloc = CommentBloc();

  void initState() {
    bloc.getComments.add("c78df9ee-2636-4b98-9c6a-ab07ab5f10b1");
  }

  void _addComment(Comment comment) {
    if (comment != null) {
      setState(() {
        widget._comments.add(comment);
      });
    }
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
          Center(
              child: StreamBuilder<List<Comment>>(
            stream: bloc.onGetComments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  Comment comment = snapshot.data[index];
                  return CommentItem(
                    avatarUrl: comment.photoUrl,
                    nickName: comment.username,
                    comment: comment.text,
                  );
                },
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: _inputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comentário',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  String avatarUrl;
  String nickName;
  String comment;

  CommentItem({this.avatarUrl, this.nickName, this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: CircleAvatar(
          //     backgroundImage: NetworkImage("${this.post.photoUrl}"),
          //     minRadius: 16,
          //   ),
          // ),
          Text(
            this.nickName + ': ',
            textAlign: TextAlign.start,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            this.comment,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
