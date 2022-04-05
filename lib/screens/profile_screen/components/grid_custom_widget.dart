import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class GridCustomWidget extends StatelessWidget {
  int columnsCount;
  String thumbnailUrl;
  VoidCallback onTap;
  String? type;
  int? discountSpacing = 0;
  double? amountPadding;

  GridCustomWidget({
    Key? key,
    required this.columnsCount,
    required this.thumbnailUrl,
    required this.onTap,
    this.type,
    this.discountSpacing = 0,
    this.amountPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        var itemWidth =
            ((constraint.maxWidth - (discountSpacing as num)) / columnsCount);
        return InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(amountPadding != null ? amountPadding! : 5),
            width: itemWidth,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: itemWidth,
                    height: itemWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (type == 'gallery')
                    Positioned(
                      top: 10,
                      right: 10,
                      child: SvgPicture.asset(
                          "assets/icons/multiple_medias_icon.svg"),
                    ),
                  Align(
                    child: type == 'video'
                        ? Image.asset("assets/icons/icon_play.png")
                        : null,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
