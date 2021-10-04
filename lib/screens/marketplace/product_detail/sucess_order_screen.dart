import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/get_adaptive_size.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class SuccessOrderScreen extends StatelessWidget {
  final TextStyle softStyle = TextStyle(color: Colors.white, fontSize: 18);

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
              margin: EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ETHICAL MARKETPLACE",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  Text(
                    "The place to exchange goods and services that positively impact our lives and the planet.",
                    style: softStyle,
                  ),
                  CircleAvatar(
                      backgroundColor: LightColors.blue,
                      radius: getAdaptiveSize(80, context),
                      child: Image.asset(
                        "assets/images/wallet.png",
                        scale: 4,
                      )),
                  Text(
                    "THANKS FOR YOUR ORDER",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                  Text(
                    "The vendor will soon contact you by email to arrange delivery of your purchase.",
                    style: softStyle,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        )),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      child: Text(
                        "Close",
                        style: TextStyle(
                            color: LightColors.silverText,
                            fontSize: 16,
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
