import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/get_adaptive_size.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class TransferSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Image.asset(
                "assets/images/success_order.png",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.symmetric(
                  horizontal: getAdaptiveSize(26, context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ETHICAL MARKETPLACE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: getAdaptiveSize(22, context)),
                  ),
                  Text(
                    "The place to exchange goods and services that positively impact our lives and the planet.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: getAdaptiveSize(18, context)),
                  ),
                  CircleAvatar(
                      backgroundColor: LightColors.blue,
                      radius: getAdaptiveSize(80, context),
                      child: Image.asset(
                        "assets/images/wallet.png",
                        scale: MediaQuery.of(context).size.width > 720 ? 2 : 4,
                      )),
                  Text(
                    "THANKS FOR YOUR ORDER",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: getAdaptiveSize(28, context)),
                  ),
                  Text(
                    "The vendor will soon contact you by email to arrange delivery of your purchase.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: getAdaptiveSize(18, context)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        )),
                    onPressed: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getAdaptiveSize(20, context),
                          vertical: getAdaptiveSize(18, context)),
                      child: Text(
                        "Close",
                        style: TextStyle(
                            color: LightColors.silverText,
                            fontSize: getAdaptiveSize(16, context),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
