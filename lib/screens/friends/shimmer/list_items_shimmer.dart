import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/friends/shimmer/item_shimmer.dart';

class ListItemsShimmer extends StatelessWidget {
  const ListItemsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 11,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ItemShimmer();
        });
  }
}
