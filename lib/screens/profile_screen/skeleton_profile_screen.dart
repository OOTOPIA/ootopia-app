import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 4,
        children: List.generate(20, (index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Color(0xffC0D9E8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
