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
            trailing: Chip(
              labelPadding: balanceOfTransactions.length == 2
                  ? EdgeInsets.only(left: 32)
                  : balanceOfTransactions.length == 3
                      ? EdgeInsets.only(left: 27)
                      : balanceOfTransactions.length == 4
                          ? EdgeInsets.only(left: 20)
                          : balanceOfTransactions.length == 5
                              ? EdgeInsets.only(left: 13)
                              : EdgeInsets.only(left: 5),
              avatar: Image.asset('assets/icons/ooz-coin-small.png'),
              backgroundColor: Colors.white,
              label: Text(
                  '${balanceOfTransactions.length > 6 ? NumberFormat.compact().format(double.parse(balanceOfTransactions)) : balanceOfTransactions}'),
            ),
          ),
        ),
      ],
    );
  }
}
