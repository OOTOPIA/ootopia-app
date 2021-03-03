import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final List<Comment> _comments = List();

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _inputController = TextEditingController();

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
              child: BlocListener<TimelinePostBloc, TimelinePostState>(
            listener: (context, state) {
              if (state is ErrorState) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            child: _blocBuilder(),
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

  _blocBuilder() {
    return BlocBuilder<TimelinePostBloc, TimelinePostState>(
      builder: (context, state) {
        if (state is InitialState) {
          return Center(
            child: Text("Initial"),
          );
        } else if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedSucessState) {
          return Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () async {
                      state.posts = [];
                      // _getData();
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        return Comment(
                          avatarUrl: widget._comments[index].avatarUrl,
                          nickName: widget._comments[index].nickName,
                          comment: widget._comments[index].comment,
                        );
                      },
                    )),
              ),
            ],
          );
        } else if (state is ErrorState) {
          return Center(child: Text("Error"));
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

class Comment extends StatelessWidget {
  String avatarUrl;
  String nickName;
  String comment;

  Comment({this.avatarUrl, this.nickName, this.comment});

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
