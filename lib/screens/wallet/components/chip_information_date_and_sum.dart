import 'package:flutter/material.dart';

class ChipSumForDate extends StatelessWidget {
  final String date;
  final lengthItemMapSumOfDayTransfer;
  final sumFormated;
  const ChipSumForDate(
      {required this.date,
      required this.lengthItemMapSumOfDayTransfer,
      required this.sumFormated});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$date',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff003694),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Chip(
            labelPadding: lengthItemMapSumOfDayTransfer == 2
                ? EdgeInsets.only(left: 32)
                : lengthItemMapSumOfDayTransfer == 3
                    ? EdgeInsets.only(left: 27)
                    : lengthItemMapSumOfDayTransfer == 4
                        ? EdgeInsets.only(left: 20)
                        : lengthItemMapSumOfDayTransfer == 5
                            ? EdgeInsets.only(left: 13)
                            : EdgeInsets.only(left: 5),
            backgroundColor: Colors.white,
            avatar: Image.asset('assets/icons/ooz-coin-small.png'),
            label: Text(
              '$sumFormated',
              style: TextStyle(
                fontSize: 14,
              ),
            ))
      ],
    );
  }
}
