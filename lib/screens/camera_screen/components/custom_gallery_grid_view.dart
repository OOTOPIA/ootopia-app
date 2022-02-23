import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/theme/light/colors.dart';

// ignore: must_be_immutable
class CustomGalleryGridView extends StatefulWidget {
  int columnsCount;
  var media;
  String mediaType;
  int? discountSpacing = 0;
  double? amountPadding;
  bool? singleMode;
  int? positionOnList;
  void Function()? onTap;

  CustomGalleryGridView({
    Key? key,
    required this.columnsCount,
    required this.media,
    required this.mediaType,
    this.discountSpacing = 0,
    this.amountPadding,
    this.singleMode,
    this.positionOnList,
    this.onTap,
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
          onTap: widget.onTap,
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
                      child: widget.mediaType == 'video'
                          ? Image.memory(
                              widget.media,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              widget.media,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  if (widget.singleMode! == false)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: widget.positionOnList != 0
                              ? LightColors.accentBlue
                              : null,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Color(0xFFFFFFFF).withOpacity(0.8)),
                        ),
                        child: Center(
                          child: Text(
                            widget.positionOnList != 0
                                ? widget.positionOnList.toString()
                                : '',
                            style: GoogleFonts.roboto(
                                color: LightColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
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
