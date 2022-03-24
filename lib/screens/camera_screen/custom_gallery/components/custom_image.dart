import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/theme/light/colors.dart';

// ignore: must_be_immutable
class CustomImage extends StatefulWidget {
  var media;
  String mediaType;
  bool? singleMode;
  int? positionOnList;
  void Function()? onTap;

  CustomImage({
    Key? key,
    required this.media,
    required this.mediaType,
    this.singleMode,
    this.positionOnList,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(
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
                      border:
                          Border.all(color: Color(0xFFFFFFFF).withOpacity(0.8)),
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
  }
}
