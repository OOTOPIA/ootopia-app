import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomGalleryGridView extends StatefulWidget {
  int columnsCount;
  var image;
  int? discountSpacing = 0;
  double? amountPadding;
  bool? singleMode;

  CustomGalleryGridView({
    Key? key,
    required this.columnsCount,
    required this.image,
    this.discountSpacing = 0,
    this.amountPadding,
    this.singleMode,
  }) : super(key: key);

  @override
  State<CustomGalleryGridView> createState() => _CustomGalleryGridViewState();
}

class _CustomGalleryGridViewState extends State<CustomGalleryGridView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        var itemWidth =
            ((constraint.maxWidth - (widget.discountSpacing as num)) /
                widget.columnsCount);
        return InkWell(
          onTap: () => print('teste'),
          child: Container(
            padding: EdgeInsets.all(
                widget.amountPadding != null ? widget.amountPadding! : 5),
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
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (widget.singleMode!)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Color(0xFFFFFFFF).withOpacity(0.8)),
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
