import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonPlayerVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 16,
      height: 232.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[100],
        highlightColor: Color(0xffC0D9E8),
        child: Container(
          width: MediaQuery.of(context).size.width - 16,
          height: 232,
          color: Colors.grey[100],
        ),
      ),
    );
  }
}
