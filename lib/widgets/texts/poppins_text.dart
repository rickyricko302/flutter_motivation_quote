import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoppinsTextWidget extends StatelessWidget {
  ///Widget Text dengan font style [nexa]
  const PoppinsTextWidget(
      {Key? key,
      required this.text,
      required this.fontColor,
      required this.fontSize,
      this.fontWeight = FontWeight.normal,
      this.maxLines = 10,
      this.textAlign = TextAlign.start})
      : super(key: key);
  final int maxLines;
  final String text;
  final Color fontColor;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines >= 1 ? TextOverflow.ellipsis : null,
      style: GoogleFonts.poppins(
        color: fontColor,
        fontSize: fontSize,
        fontWeight:
            fontWeight == FontWeight.bold ? FontWeight.w600 : fontWeight,
      ),
    );
  }
}
