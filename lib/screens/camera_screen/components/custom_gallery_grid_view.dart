import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomGalleryGridView extends StatelessWidget {
  int columnsCount;
  var image;
  int? discountSpacing = 0;
  double? amountPadding;

  CustomGalleryGridView({
    Key? key,
    required this.columnsCount,
    required this.image,
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
          onTap: () => print('teste'),
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
                      child: Image.memory(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
