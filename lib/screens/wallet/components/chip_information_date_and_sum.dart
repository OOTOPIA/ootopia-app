import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

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
      children: [
        Text(
          // day
          '${today == widget.date ? 'Today' : widget.date}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff003694),
            fontSize: getAdaptiveSize(18, context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          // total by day
          width: getAdaptiveSize(80, context),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(PageRoute.Page.aboutOOzCurrentScreen.route);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/icons/ooz-coin-blue-small.svg',
                  color: Color(0xff003694),
                  height: getAdaptiveSize(10, context),
                ),
                Text(
                  ' ${double.parse(this.widget.sumFormated).isNegative ? '-' : ''} ${widget.sumFormated.length > 6 ? NumberFormat.compact().format(double.parse(widget.sumFormated.replaceAll('-', ''))).replaceAll('.', ',') : this.widget.sumFormated.replaceAll('-', '').replaceAll('.', ',')}',
                  style: TextStyle(
                      fontSize: getAdaptiveSize(14, context),
                      color: Color(0xff003694),
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
