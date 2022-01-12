import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/persona_level/ripple_animationA.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class PersonaLevel extends StatefulWidget {
  final double percent;

  const PersonaLevel({ required this.percent});

  @override
  _PersonaLevelState createState() => _PersonaLevelState();
}

class _PersonaLevelState extends State<PersonaLevel> {
  late AuthStore? authStore;
  late String urlImage;
  late String name;

  void _init(BuildContext context){
    authStore = Provider.of<AuthStore>(context);
    urlImage = authStore?.currentUser?.photoUrl ?? '';
    name = authStore?.currentUser?.fullname ?? '';
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Container(
      height: MediaQuery.of(context).size.height - (246.2),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/map3.png',
            ),
            alignment: Alignment(-0.6, -1),
            fit: BoxFit.cover,
            //alignment: Alignment.centerLeft,
          )),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width*0.2),
              height: MediaQuery.of(context).size.width/3,
              width: MediaQuery.of(context).size.width*0.4,
              color: Colors.transparent,
              child: Stack(
                children: [
                  RipplesAnimation(
                    color: Color(0xffB1E3FD),
                    size: MediaQuery.of(context).size.width*0.4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: urlImage.isEmpty
                          ? Image.asset(
                        'assets/icons/user.png',
                        height: MediaQuery.of(context).size.width/3 - MediaQuery
                            .of(context).size.width/9,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        urlImage,
                        height: MediaQuery.of(context).size.width/3 - MediaQuery.of(context).size.width/9,
                        width: MediaQuery.of(context).size.width/3 - MediaQuery.of(context).size.width/9,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircularPercentIndicator(
                        radius: MediaQuery.of(context).size.width/3 - MediaQuery.of(context).size.width/9,
                        lineWidth: 5,
                        backgroundColor: Color(0xffFAFAFA),
                        percent:   widget.percent,
                        linearGradient: LinearGradient(colors: [Color(0xff3ABBFE), Color(0xff002E7D)],)),
                  ),

                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.width*0.2,

              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xff2CB4FB), width: 2)
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff707070)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
