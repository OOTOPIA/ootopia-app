import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ChipSumForDate extends StatefulWidget {
  final String date;
  final lengthItemMapSumOfDayTransfer;
  final String sumFormated;
  const ChipSumForDate(
      {required this.date,
      required this.lengthItemMapSumOfDayTransfer,
      required this.sumFormated});

  @override
  _ChipSumForDateState createState() => _ChipSumForDateState();
}

class _ChipSumForDateState extends State<ChipSumForDate> {
  @override
  Widget build(BuildContext context) {
    String today = DateFormat('MMM d, y').format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${today == widget.date ? 'Today' : widget.date}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff003694),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Chip(
            labelPadding: widget.lengthItemMapSumOfDayTransfer == 2
                ? EdgeInsets.only(left: 32)
                : widget.lengthItemMapSumOfDayTransfer == 3
                    ? EdgeInsets.only(left: 27)
                    : widget.lengthItemMapSumOfDayTransfer == 4
                        ? EdgeInsets.only(left: 20)
                        : widget.lengthItemMapSumOfDayTransfer == 5
                            ? EdgeInsets.only(left: 13)
                            : EdgeInsets.only(left: 5),
            backgroundColor: Colors.white,
            avatar: SvgPicture.asset(
              'assets/icons/ooz-coin-blue-small.svg',
              color: Color(0xff003694),
            ),
            label: Text(
              '${widget.sumFormated.replaceAll('.', ',')}',
              style: TextStyle(
                fontSize: 14,
              ),
            ))
      ],
    );
  }
}
