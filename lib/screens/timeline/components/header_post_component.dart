import 'package:flutter/material.dart';

class HeaderPostComponent extends StatelessWidget {
  final String username;
  final String? photoUrl;
  final String? city;
  final String? state;
  final Function()? goToProfile;
  late bool hasCity;
  late bool hasState;
  HeaderPostComponent({
    Key? key,
    required this.username,
    this.photoUrl,
    this.city,
    this.state,
    this.goToProfile,
  }) : super(key: key);


  init(){
    hasCity = city?.isNotEmpty ?? false;
    hasState = city?.isNotEmpty ?? false;
  }

  @override
  Widget build(BuildContext context) {
    init();
    return GestureDetector(
      onTap: () => goToProfile!(),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 6.0,
              right: 6.0,
              bottom: 6.0,
            ),
            child: this.photoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage("${this.photoUrl}"),
                    radius: 16,
                  )
                : CircleAvatar(
                    backgroundImage: AssetImage("assets/icons/user.png"),
                    radius: 16,
                  ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - (44 + 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.username,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Visibility(
                  visible: hasCity || hasState,
                  child: Text(
                    '${this.city}' +
                        (hasState
                            ? ', ${this.state}'
                            : ''),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
