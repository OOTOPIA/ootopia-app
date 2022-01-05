import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonaLevel extends StatefulWidget {


  @override
  _PersonaLevelState createState() => _PersonaLevelState();
}

class _PersonaLevelState extends State<PersonaLevel> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - (180 + 59 + 6),
      width: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/map.png',
            ),
            fit: BoxFit.cover,
          )),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width/3),
              height: MediaQuery.of(context).size.width/3,
              width: MediaQuery.of(context).size.width/3,
              color: Colors.brown,
            ),
          )
        ],
      ),
    );
  }
}
