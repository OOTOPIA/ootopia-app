import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChipSumForDate extends StatefulWidget {
  final String date;
  final String sumFormated;
  const ChipSumForDate(
      {required this.date,
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
          '${today == widget.date ? AppLocalizations.of(context)!.today : widget.date}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff003694),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          // total by day
          width: 80,
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
                  height: 10,
                ),
                Text(
                  ' ${double.parse(this.widget.sumFormated).isNegative ? '-' : ''} ${widget.sumFormated.length > 6 ? NumberFormat.compact().format(double.parse(widget.sumFormated.replaceAll('-', ''))).replaceAll('.', ',') : this.widget.sumFormated.replaceAll('-', '').replaceAll('.', ',')}',
                  style: TextStyle(
                      fontSize: 14,
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
