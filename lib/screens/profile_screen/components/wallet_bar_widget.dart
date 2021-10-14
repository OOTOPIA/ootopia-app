import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletBarWidget extends StatefulWidget {
  final Function onTap;
  final String totalBalance;
  WalletBarWidget({Key? key, required this.onTap, required this.totalBalance})
      : super(key: key);

  @override
  State<WalletBarWidget> createState() => _WalletBarWidgetState();
}

class _WalletBarWidgetState extends State<WalletBarWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
        width: double.maxFinite,
        height: 60,
        padding: EdgeInsets.symmetric(
            horizontal: GlobalConstants.of(context).intermediateSpacing),
        decoration: BoxDecoration(color: Color(0xff707070).withOpacity(.05)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/icons/ooz-coin-black.png",
                  width: 22,
                ),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.wallet,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.currentOOZBalance,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/ooz_only_active.png",
                          width: 20,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.totalBalance,
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff003694),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xff03145C),
                    size: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
