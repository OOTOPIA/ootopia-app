import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardInformationBalance extends StatelessWidget {
  final String imageAvatar;
  final String imageRectangulo;
  final String balanceOfTransactions;
  final String originTransaction;
  final String toOrFrom;

  CardInformationBalance(this.balanceOfTransactions, this.imageAvatar,
      this.imageRectangulo, this.toOrFrom, this.originTransaction);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: 90,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  '$imageRectangulo',
                  width: 75,
                ),
              ),
              Positioned(
                right: 5,
                bottom: 15,
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(
                    '$imageAvatar',
                  )),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: ListTile(
            contentPadding: EdgeInsets.only(top: 15, left: 5),
            title: Text(
              'Regeneration Game',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$originTransaction',
                  style: TextStyle(
                    color: Color(0xff018F9C),
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'from',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' $toOrFrom',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
            trailing: Wrap(
              spacing: 30,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Image.asset('assets/icons/ooz-coin-small.png'),
                Text(
                    '${balanceOfTransactions.length > 7 ? NumberFormat.compact().format(double.parse(balanceOfTransactions)) : balanceOfTransactions}')
              ],
            ),
            // trailing: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [

            //     Image.asset('assets/icons/ooz-coin-small.png'),
            //     if (balanceOfTransactions.length == 5)
            //       SizedBox(
            //         width: 35,
            //       ),
            //     if (balanceOfTransactions.length == 3)
            //       SizedBox(
            //         width: 47,
            //       ),
            //     if (balanceOfTransactions.length == 4)
            //       SizedBox(
            //         width: 47,
            //       ),
            //     if (balanceOfTransactions.length == 6)
            //       SizedBox(
            //         width: 26,
            //       ),
            //     Text(
            //         '${balanceOfTransactions.length > 7 ? NumberFormat.compact().format(double.parse(balanceOfTransactions)) : balanceOfTransactions}')
            //   ],
            // ),
          ),
        ),
      ],
    );
  }
}
