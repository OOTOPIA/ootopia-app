import 'package:flutter/material.dart';

class GridCustomWidget extends StatelessWidget {
  int columnsCount;
  String thumbnailUrl;
  VoidCallback onTap;

  GridCustomWidget({
    Key? key,
    required this.columnsCount,
    required this.thumbnailUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        var itemWidth = (constraint.maxWidth / columnsCount);
        return InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(5),
            width: itemWidth,
            child: Center(
              child: SizedBox(
                width: itemWidth,
                height: itemWidth * .90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
