import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CardInformationBalance extends StatelessWidget {
  final String imageAvatar;
  final String imageRectangulo;
  final String balanceOfTransactions;
  final String originTransaction;
  final String toOrFrom;
  final int colorOfOzz;
  final String typeActionFromOrTo;

  CardInformationBalance(
      this.balanceOfTransactions,
      this.imageAvatar,
      this.imageRectangulo,
      this.toOrFrom,
      this.originTransaction,
      this.colorOfOzz,
      this.typeActionFromOrTo);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 15, left: 5),
      leading: Container(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                '$imageRectangulo',
                width: 60,
                height: 50,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(
                    '$imageAvatar',
                  )),
            ),
          ],
        ),
      ),
      title: Text(
        'Regeneration Game',
        style: TextStyle(color: Color(0xff018F9C), fontSize: 12),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$originTransaction',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Text(
                '$typeActionFromOrTo',
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
        avatar: SvgPicture.asset(
          'assets/icons/ooz-coin-blue-small.svg',
          color: Color(colorOfOzz),
        ),
        backgroundColor: Colors.white,
        label: Text(
            '${balanceOfTransactions.length > 6 ? NumberFormat.compact().format(double.parse(balanceOfTransactions)).replaceAll('.', ',') : balanceOfTransactions.replaceAll('.', ',')}'),
      ),
    );
  }
}
