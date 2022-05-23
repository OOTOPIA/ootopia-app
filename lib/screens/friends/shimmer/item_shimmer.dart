import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemShimmer extends StatelessWidget {
  const ItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width - (25 + 14 + 48 + 82);
    return Shimmer.fromColors(
      baseColor: Colors.grey[300] ?? Colors.blue,
      highlightColor: Colors.grey[100] ?? Colors.blue,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(25, 16, 25, 0),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 11,
                        width: size * 0.35,
                        color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        height: 8,
                        width: size * 0.23,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 24,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ],
            ),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 25 : 8,
                      top: 14,
                      right: index == 4 ? 14 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: 76,
                    width: 74,
                  );
                }),
          )
        ],
      ),
    );
  }
}
