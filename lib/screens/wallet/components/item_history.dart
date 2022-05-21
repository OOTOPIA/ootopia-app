import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/wallet/components/card_information_balance.dart';
import 'package:ootopia_app/screens/wallet/components/chip_information_date_and_sum.dart';

class ItemHistory extends StatelessWidget {
  final String dayTitle;
  final sumFormatted;
  final List daysItem;
  final performRequest;
  const ItemHistory({Key? key,
    required this.dayTitle,
    required this.daysItem,
    required this.performRequest,
    required this.sumFormatted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: 16,
            ),
            child: ChipSumForDate(
              date: dayTitle,
              sumFormated: sumFormatted,
            ),
          ),
          ListView.builder(
              itemCount: daysItem.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.only(
                    bottom: 19,
                  ),
                  child: CardInformationBalance(
                    balanceOfTransactions: '${daysItem[index].balance.toStringAsFixed(2)}',
                    iconForeground: daysItem[index].photoUrl ?? "",
                    iconBackground: daysItem[index].icon ?? '',
                    toOrFrom: daysItem[index].otherUsername ?? '',
                    originTransaction: '${daysItem[index].origin}',
                    action: '${daysItem[index].action}',
                    otherUserId: '${daysItem[index].otherUserId}',
                    postId: daysItem[index].postId,
                    description: daysItem[index].description,
                    origin: daysItem[index].origin,
                    learningTrackId: daysItem[index].learningTrackId ?? '',
                    updateCardInformationBalance: performRequest,
                  ),
                );
              },
          ),
        ],
      ),
    );
  }
}