import 'package:flutter/material.dart';

class PopupMenuPost extends StatefulWidget {
  final bool isAnabled;
  final Function callbackReturnPopupMenu;

  PopupMenuPost({this.isAnabled = true, this.callbackReturnPopupMenu});
  @override
  _PopupMenuPostState createState() => _PopupMenuPostState();
}

class _PopupMenuPostState extends State<PopupMenuPost> {
  _selectedOption(String optionSelected) {
    switch (optionSelected) {
      case 'Excluir':
        widget.callbackReturnPopupMenu(optionSelected);

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      enabled: widget.isAnabled,
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                child: Icon(Icons.delete),
                padding: EdgeInsets.only(right: 4),
              ),
              Text(
                'Excluir',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
          value: 'Excluir',
        ),
      ],
      onSelected: (_) => _selectedOption(_),
    );
  }
}
